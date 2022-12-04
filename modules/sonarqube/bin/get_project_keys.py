#!/usr/bin/env python3
import sys
import json
import subprocess


def get_keyvault_secret(keyvault_name, name):
    return subprocess.check_output([
        'az', 'keyvault', 'secret', 'download', '--name', name,
        '--vault-name', keyvault_name, '--file', '/dev/stdout'
    ]).decode().strip()


def main(keyvault_name, admin_token_secret_name, sonarqube_url):
    admin_token = get_keyvault_secret(keyvault_name, admin_token_secret_name)
    print(json.dumps({
        project['name']: project['key']
        for project in json.loads(subprocess.check_output([
            'curl', '-su', f'{admin_token}:',
            f'{sonarqube_url}/api/projects/search'
        ]))['components']
    }))


if __name__ == '__main__':
    main(*sys.argv[1:])
