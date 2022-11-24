#!/usr/bin/env python3
import sys
import json
import subprocess


def get_environment_key_vault_name(environment_name):
    return json.loads(subprocess.check_output([
        'terraform', f'-chdir=environments/{environment_name}/core', 'output', '-json', 'core_resources'
    ]).decode())['key_vault']['name']


def main(environment_name, secret_name, value):
    print(f'Setting {secret_name} in environment {environment_name} default key vault')
    subprocess.check_call([
        'az', 'keyvault', 'secret', 'set',
        '--vault-name', get_environment_key_vault_name(environment_name),
        '--name', secret_name,
        '--value', value,
    ])
    print('OK')


if __name__ == '__main__':
    main(*sys.argv[1:])
