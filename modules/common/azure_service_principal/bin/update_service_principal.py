#!/usr/bin/env python3
import sys
import time
import json
import subprocess


def set_secret(keyvault_name, name, value):
    subprocess.check_call([
        'az', 'keyvault', 'secret', 'set', '--name', name, '--vault-name', keyvault_name,
        '--value', value
    ])


def create_for_rbac(name, role, scopes, raise_exception=True):
    try:
        return json.loads(subprocess.check_output([
            'az', 'ad', 'sp', 'create-for-rbac',
            '-n', name,
            *(['--role', role] if role else []),
            *(['--scopes', scopes] if scopes else []),
            '--years', '100'
        ]))['password']
    except:
        if raise_exception:
            raise
        else:
            return None


def create_for_rbac_retry(name, role, scopes, retry):
    if retry:
        for i in [1, 2, 3]:
            password = create_for_rbac(name, role, scopes, raise_exception=False)
            if password is None:
                time.sleep(i * 3)
            else:
                return password
    return create_for_rbac(name, role, scopes)


def main(name, role, scopes, keyvault_name, password_secret_name, *args):
    retry = '--retry' in args
    print(f'Updating service principal {name} with role "{role}", scopes "{scopes}" in keyvault {keyvault_name} secret {password_secret_name}')
    password = create_for_rbac_retry(name, role, scopes, retry)
    set_secret(keyvault_name, password_secret_name, password)
    print('OK')


if __name__ == '__main__':
    main(*sys.argv[1:])
