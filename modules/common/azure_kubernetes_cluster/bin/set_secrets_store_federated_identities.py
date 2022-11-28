#!/usr/bin/env python3
import sys
import json
import tempfile
import subprocess


def main(application_object_id, issuer, service_accounts, name_prefix):
    with tempfile.TemporaryDirectory() as tmpdir:
        for service_account in service_accounts.split(','):
            name = f'{name_prefix}-k8skv-{service_account.replace(":", "-")}'
            if subprocess.call([
                'az' ,'ad', 'app', 'federated-credential', 'show',
                '--id', application_object_id,
                '--federated-credential-id', name,
            ]) != 0:
                print(f'Creating federated identity credential {name}...')
                with open(f'{tmpdir}/params.json', 'w') as f:
                    json.dump({
                        'name': name,
                        'issuer': issuer,
                        'subject': f'system:serviceaccount:{service_account}',
                        'description': 'Kubernetes service account federated identity',
                        'audiences': [
                            'api://AzureADTokenExchange'
                        ]
                    }, f)
                subprocess.check_call([
                    'az', 'ad', 'app', 'federated-credential', 'create',
                    '--id', application_object_id,
                    '--parameters', f'{tmpdir}/params.json',
                ])
                print('OK')


if __name__ == '__main__':
    main(*sys.argv[1:])
