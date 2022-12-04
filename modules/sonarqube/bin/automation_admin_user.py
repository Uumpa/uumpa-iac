#!/usr/bin/env python3
import sys
import json
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


def main(keyvault_name, name_secret_name, password_secret_name, sonarqube_url, token_secret_name):
    print("Checking SonarQube admin automation user...")
    name = get_keyvault_secret(keyvault_name, name_secret_name)
    password = get_keyvault_secret(keyvault_name, password_secret_name)
    if not name or not password:
        print('Please create an automation admin user in SonarQube and set credentials in secrets:')
        print(f'   az keyvault secret set --vault-name {keyvault_name} --name {name_secret_name} --value <name>')
        print(f'   az keyvault secret set --vault-name {keyvault_name} --name {password_secret_name} --value <password>')
        exit(1)
    print("Checking SonarQube admin automation user token...")
    if not get_keyvault_secret(keyvault_name, token_secret_name):
        token = json.loads(subprocess.check_output([
            'curl', '-u', f'{name}:{password}', '-X', 'POST',
            f'{sonarqube_url}/api/user_tokens/generate',
            '-d', 'name=automation-admin'
        ]))['token']
        set_keyvault_secret(keyvault_name, token_secret_name, token)
    print("OK")


if __name__ == '__main__':
    main(*sys.argv[1:])
