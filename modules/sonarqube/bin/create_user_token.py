#!/usr/bin/env python3
import sys
import json
import secrets
import subprocess


def get_keyvault_secret(keyvault_name, name):
    p = subprocess.run([
        'az', 'keyvault', 'secret', 'download', '--name', name,
        '--vault-name', keyvault_name, '--file', '/dev/stdout'
    ], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if p.returncode != 0:
        print(p.stdout.decode())
        return None
    else:
        return p.stdout.decode().strip()


def set_keyvault_secret(keyvault_name, secret_name, value):
    subprocess.check_call([
        'az', 'keyvault', 'secret', 'set',
        '--vault-name', keyvault_name,
        '--name', secret_name,
        '--value', value,
    ])


def generate_password():
    return secrets.token_urlsafe(20)


def main(keyvault_name, admin_token_secret_name, user_name, sonarqube_url, token_secret_name, token_name):
    print(f"Checking user token for user {user_name}...")
    admin_token = get_keyvault_secret(keyvault_name, admin_token_secret_name)
    if not get_keyvault_secret(keyvault_name, token_secret_name):
        subprocess.check_call([
            'curl', '-u', f'{admin_token}:', '-X', 'POST',
            f'{sonarqube_url}/api/users/create',
            '-d', f'login={user_name}&name={user_name}&password={generate_password()}'
        ])
        token = json.loads(subprocess.check_output([
            'curl', '-u', f'{admin_token}:', '-X', 'POST',
            f'{sonarqube_url}/api/user_tokens/generate',
            '-d', f'name={token_name}&login={user_name}'
        ]))['token']
        set_keyvault_secret(keyvault_name, token_secret_name, token)
    print("OK")


if __name__ == '__main__':
    main(*sys.argv[1:])
