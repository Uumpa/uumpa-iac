#!/usr/bin/env python3
import sys
import json
import subprocess


def check_call(*args, **kwargs):
    try:
        subprocess.check_call(*args, **kwargs)
    except subprocess.CalledProcessError as e:
        exit(e.returncode)


def get_environment_key_vault_name(environment_name):
    return json.loads(subprocess.check_output([
        'bin/terraform.py', environment_name, 'core', 'output', '-json', 'core'
    ]).decode())['default_key_vault']['name']


def main(environment_name, secret_name):
    check_call([
        'az', 'keyvault', 'secret', 'download',
        '--vault-name', get_environment_key_vault_name(environment_name),
        '--name', secret_name,
        '--file', '/dev/stdout'
    ])


if __name__ == '__main__':
    main(*sys.argv[1:])
