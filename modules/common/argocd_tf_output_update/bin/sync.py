#!/usr/bin/env python3
import sys
import subprocess


def get_keyvault_secret(keyvault_name, name):
    return subprocess.check_output([
        'az', 'keyvault', 'secret', 'download', '--name', name,
        '--vault-name', keyvault_name, '--file', '/dev/stdout'
    ]).decode()


def main(token_secret_name, key_vault_name, domain, application):
    token = get_keyvault_secret(key_vault_name, token_secret_name)
    subprocess.check_call([
        'curl', '-H', f'Authorization: Bearer {token}',
        f'https://{domain}/api/v1/applications/{application}?refresh=hard'
    ])


if __name__ == "__main__":
    main(*sys.argv[1:])
