#!/usr/bin/env python3
import sys
import json
import subprocess
from textwrap import dedent


def get_keyvault_secret(keyvault_name, name):
    return subprocess.check_output([
        'az', 'keyvault', 'secret', 'download', '--name', name,
        '--vault-name', keyvault_name, '--file', '/dev/stdout'
    ]).decode()


def main(root_domain, azuread_group_default_kubernetes_admins, uumpa_iac_repo_remote_url, plugin_docker_image, keyvault_name):
    print("Deploying ArgoCD...")
    # These values need to be set manually, see docs/bootstrap.md
    saml_ssoUrl = get_keyvault_secret(keyvault_name, 'argocd-saml-ssourl')
    saml_cert = get_keyvault_secret(keyvault_name, 'argocd-saml-cert')
    uumpa_iac_repo_token = get_keyvault_secret(keyvault_name, 'argocd-azdo-token')
    if subprocess.call(['kubectl', 'get', 'ns', 'argocd']) != 0:
        subprocess.check_call(['kubectl', 'create', 'ns', 'argocd'])
    subprocess.run(['kubectl', 'apply', '-n', 'argocd', '-f', '-'], check=True, input=json.dumps({
        'apiVersion': 'v1',
        'kind': 'ConfigMap',
        'metadata': {
            'name': 'argocd-cm',
            'labels': {
                'app.kubernetes.io/name': 'argocd-cm',
                'app.kubernetes.io/part-of': 'argocd',
            }
        },
        'data': {
            'url': f'https://argocd.{root_domain}',
            'admin.enabled': 'false',
            'dex.config': dedent(f'''
                logger:
                  level: debug
                  format: json
                connectors:
                - type: saml
                  id: saml
                  name: saml
                  config:
                    entityIssuer: https://argocd.{root_domain}/api/dex/callback
                    ssoURL: {saml_ssoUrl}
                    caData: {saml_cert}
                    redirectURI: https://{root_domain}/api/dex/callback
                    usernameAttr: email
                    emailAttr: email
                    groupsAttr: Group
            ''').strip(),
            'configManagementPlugins': dedent(f'''
                - name: argocd-iac-plugin-helm-with-args
                  init:
                    command: ["argocd_iac_plugin.py", "init", "."]
                  generate:
                    command: ["sh", "-c"]
                    args: ['argocd_iac_plugin.py generate . "$ARGOCD_APP_NAME" "$ARGOCD_APP_NAMESPACE" ${{ARGOCD_ENV_helm_args}}']
            ''').strip(),
        }
    }).encode())
    subprocess.run(['kubectl', 'apply', '-n', 'argocd', '-f', '-'], check=True, input=json.dumps({
        'apiVersion': 'v1',
        'kind': 'ConfigMap',
        'metadata': {
            'name': 'argocd-rbac-cm',
            'labels': {
                'app.kubernetes.io/name': 'argocd-rbac-cm',
                'app.kubernetes.io/part-of': 'argocd',
            }
        },
        'data': {
            # any authenticated user has readonly
            'policy.default': 'role: readonly',
            # default kubernetes admins group has role:admin
            'policy.csv': dedent(f'''
               g, "{azuread_group_default_kubernetes_admins}", role:admin
            ''').strip()
        }
    }).encode())
    subprocess.run(['kubectl', 'apply', '-n', 'argocd', '-f', '-'], check=True, input=json.dumps({
        'apiVersion': 'networking.k8s.io/v1',
        'kind': 'Ingress',
        'metadata': {
            'name': 'argocd-server-https',
        },
        'spec': {
            'ingressClassName': 'nginx',
            'rules': [{
                'host': f'argocd.{root_domain}',
                'http': {
                    'paths': [{
                        'path': '/',
                        'pathType': 'Prefix',
                        'backend': {
                            'service': {
                                'name': 'argocd-server',
                                'port': {
                                    'name': 'http'
                                }
                            }
                        }
                    }]
                }
            }]
        }
    }).encode())
    subprocess.run(['kubectl', 'apply', '-n', 'argocd', '-f', '-'], check=True, input=json.dumps({
        'apiVersion': 'networking.k8s.io/v1',
        'kind': 'Ingress',
        'metadata': {
            'name': 'argocd-server-grpc',
        },
        'spec': {
            'ingressClassName': 'nginx',
            'rules': [{
                'host': f'argocd-grpc.{root_domain}',
                'http': {
                    'paths': [{
                        'path': '/',
                        'pathType': 'Prefix',
                        'backend': {
                            'service': {
                                'name': 'argocd-server',
                                'port': {
                                    'name': 'https'
                                }
                            }
                        }
                    }]
                }
            }]
        }
    }).encode())
    subprocess.run(['kubectl', 'apply', '-n', 'argocd', '-f', '-'], check=True, input=json.dumps({
        'apiVersion': 'v1',
        'kind': 'Secret',
        'metadata': {
            'name': 'uumpa-argocd-private-repo',
            'labels': {
                'argocd.argoproj.io/secret-type': 'repository'
            }
        },
        'stringData': {
            'type': 'git',
            'url': uumpa_iac_repo_remote_url,
            'username': 'uumpa',
            'password': uumpa_iac_repo_token,
        }
    }).encode())
    with open('apps/argocd/argocd-repo-server-deploy.yaml.template') as rf:
        with open('apps/argocd/argocd-repo-server-deploy.yaml', 'w') as wf:
            wf.write(rf.read().replace('__PLUGIN_DOCKER_IMAGE__', plugin_docker_image))
    subprocess.check_call(['kubectl', 'apply', '-n', 'argocd', '-k', 'apps/argocd'])
    print("OK")


if __name__ == '__main__':
    main(*sys.argv[1:])
