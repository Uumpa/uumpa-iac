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
    pass


if __name__ == '__main__':
    main(*sys.argv[1:])
