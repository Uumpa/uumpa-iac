#!/usr/bin/env python3
import sys
import secrets
import subprocess


def main(keyvault_name, secret_name, user_principal):
    print(f"Generating password for user {user_principal} and storing in vault {keyvault_name} secret {secret_name}...")
    password = secrets.token_urlsafe(32)
    subprocess.check_call([
        'az', 'ad', 'user', 'update', '--id', user_principal,
        '--force-change-password-next-sign-in', 'false',
        '--password', password
    ])
    subprocess.check_call([
        'az', 'keyvault', 'secret', 'set', '--name', secret_name,
        '--vault-name', keyvault_name, '--value', password
    ])
    print("OK")


if __name__ == '__main__':
    main(*sys.argv[1:])
