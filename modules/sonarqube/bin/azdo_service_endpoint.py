#!/usr/bin/env python3
import sys
import json
import tempfile
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


def get_service_endpoint_id(name):
    return subprocess.check_output([
        'az', 'devops', 'service-endpoint', 'list', '--query', f'[?name==\'{name}\'].id',
        '--output', 'tsv'
    ]).decode().strip()


def main(name, url, token_secret_name, keyvault_name, project_id):
    token = get_keyvault_secret(keyvault_name, token_secret_name)
    service_endpoint_id = get_service_endpoint_id(name)
    if service_endpoint_id:
        subprocess.check_call([
            'az', 'devops', 'service-endpoint', 'delete', '--yes', '--id', service_endpoint_id
        ])
    with tempfile.TemporaryDirectory() as temp_dir:
        config_filename = f'{temp_dir}/config.json'
        with open(config_filename, 'w') as f:
            json.dump({
                "name": name,
                "type": "sonarqube",
                "url": url,
                "authorization": {
                    "parameters": {
                        "username": token,
                        "password": ""
                    },
                    "scheme": "UsernamePassword"
                },
                "owner": "Library",
            }, f)
        service_endpoint_id = json.loads(subprocess.check_output([
            'az', 'devops', 'service-endpoint', 'create',
            '--service-endpoint-configuration', config_filename,
            '-p', project_id
        ]))['id']
    subprocess.check_call([
        'az', 'devops', 'service-endpoint', 'update',
        '--id', service_endpoint_id, '--enable-for-all'
    ])


if __name__ == '__main__':
    main(*sys.argv[1:])
