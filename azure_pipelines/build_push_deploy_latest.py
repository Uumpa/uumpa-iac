#!/usr/bin/env python3
import os
import json
import argparse
import subprocess


ACR_REGISTRY_NAME = os.environ.get("ACR_REGISTRY_NAME")
ACR_REGISTRY_LOGIN_SERVER = os.environ.get("ACR_REGISTRY_LOGIN_SERVER")
APPCONFIG_NAME = os.environ.get('APPCONFIG_NAME')
ARGOCD_TOKEN = os.environ.get("ARGOCD_TOKEN")
ARGOCD_DOMAIN = os.environ.get("ARGOCD_DOMAIN")


def get_argument_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--image-name', required=True)
    parser.add_argument('--image-tag', required=True)
    parser.add_argument('--docker-path', required=True)
    parser.add_argument('--appconfig-key', required=True)
    parser.add_argument('--argocd-application-name')
    parser.add_argument('--kubectl-patch-json')
    return parser


def main(image_name, image_tag, docker_path, appconfig_key, argocd_application_name=None, kubectl_patch_json=None):
    image_name = f'{ACR_REGISTRY_LOGIN_SERVER}/{image_name}'
    kubectl_patch = json.loads(kubectl_patch_json) if kubectl_patch_json else None
    subprocess.check_call(['az', 'acr', 'login', '--name', ACR_REGISTRY_NAME])
    cache_from_args = []
    if subprocess.call(['docker', 'pull', f'{image_name}:latest']) == 0:
      cache_from_args = ['--cache-from', f'{image_name}:latest']
    subprocess.check_call([
      'docker', 'build', *cache_from_args, '-t', f'{image_name}:{image_tag}', '-t', f'{image_name}:latest', docker_path
    ])
    for image in [f'{image_name}:{image_tag}', f'{image_name}:latest']:
      subprocess.check_call(['docker', 'push', image])
    subprocess.check_call([
      'az', 'appconfig', 'kv', 'set', '-y',
      '--name', APPCONFIG_NAME,
      '--key', appconfig_key, '--value', f'{image_name}:{image_tag}'
    ])
    if argocd_application_name:
        subprocess.check_call([
            'curl', '-H', f'Authorization: Bearer {ARGOCD_TOKEN}',
            f'https://{ARGOCD_DOMAIN}/api/v1/applications/{argocd_application_name}?refresh=hard'
        ])
    if kubectl_patch:
        subprocess.check_call([
            'kubectl', 'patch', '-n', kubectl_patch['namespace'],
            kubectl_patch.get('kind', 'deployment'), kubectl_patch['name'],
            '-p', json.dumps({
                "spec": {
                    "template": {
                        "spec": {
                            "containers": [
                                {"name":kubectl_patch['container_name'], "image": f'{image_name}:{image_tag}'}
                            ]
                        }
                    }
                }
            })
        ])


if __name__ == '__main__':
    main(**vars(get_argument_parser().parse_args()))
