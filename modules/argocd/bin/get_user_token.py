#!/usr/bin/env python3
import sys
import json
import base64
import subprocess


def set_keyvault_secret(keyvault_name, secret_name, value):
    subprocess.check_call([
        'az', 'keyvault', 'secret', 'set',
        '--vault-name', keyvault_name,
        '--name', secret_name,
        '--value', value,
    ])


def main(domain, user_name, keyvault_name, secret_name):
    print(f'Getting token for user {user_name}...')
    admin_password = base64.b64decode(subprocess.check_output([
        "kubectl", "get", "secret", "-n", "argocd", "argocd-initial-admin-secret", "-o", "jsonpath={.data.password}"
    ])).decode().strip()
    admin_token = json.loads(subprocess.check_output([
        'curl', f'https://{domain}/api/v1/session',
        '-d', f'{{"username": "admin", "password": "{admin_password}"}}'
    ]).decode())['token']
    user_token = json.loads(subprocess.check_output([
        'curl', '-XPOST',
        '-H', f'Authorization: Bearer {admin_token}',
        f'https://{domain}/api/v1/account/{user_name}/token',
        '-d', '{}'
    ]).decode())['token']
    set_keyvault_secret(keyvault_name, secret_name, user_token)
    print('OK')


if __name__ == '__main__':
    main(*sys.argv[1:])