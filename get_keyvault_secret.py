#!/usr/bin/env python3
import os
import sys
import subprocess


VAULT_NAME = 'uumpa'


def get_keyvault_secret(name):
    if os.environ.get(f'KEYVAULT_{name}'):
        return os.environ[f'KEYVAULT_{name}']
    try:
        return subprocess.check_output([
            'az', 'keyvault', 'secret', 'download', '--name', name,
            '--vault-name', VAULT_NAME, '--file', '/dev/stdout'
        ]).decode()
    except:
        print(f'ERROR: {name} not found in keyvault')
        raise


if __name__ == '__main__':
    print(get_keyvault_secret(sys.argv[1]))
