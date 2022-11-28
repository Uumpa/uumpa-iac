#!/usr/bin/env python3
import os
import sys
import tempfile
import subprocess


def set_keyvault_secret(keyvault_name, secret_name, value):
    subprocess.check_call([
        'az', 'keyvault', 'secret', 'set',
        '--vault-name', keyvault_name,
        '--name', secret_name,
        '--value', value,
    ])


def main(key_comment, keyvault_name, base_secret_name):
    with tempfile.TemporaryDirectory() as tmpdir:
        private_filename = os.path.join(tmpdir, 'id_rsa')
        public_filename = f'{private_filename}.pub'
        subprocess.check_call([
            # Azure DevOps doesn't support ed25519 keys, so we use rsa.
            'ssh-keygen', '-t', 'rsa', '-C', key_comment,
            '-N', '', '-f', private_filename
        ])
        with open(public_filename) as f:
            public_key = f.read()
        with open(private_filename) as f:
            private_key = f.read()
    set_keyvault_secret(keyvault_name, f'{base_secret_name}-public', public_key)
    set_keyvault_secret(keyvault_name, f'{base_secret_name}-private', private_key)
    print("OK")


if __name__ == '__main__':
    main(*sys.argv[1:])