#!/usr/bin/env python3
import os
import json
import datetime
import subprocess
import sys
from textwrap import dedent


def getpwd():
    return subprocess.check_output(['pwd']).decode().strip()


def main(vault_name, secret_name, root_domain, letsencrypt_email, resource_group, *args):
    in_cluster = "--in-cluster" in args
    force = "--force" in args
    try:
        expires = json.loads(subprocess.check_output([
            'az', 'keyvault', 'certificate', 'show', '--vault-name', vault_name,
            '--name', secret_name
        ], stderr=subprocess.PIPE))['attributes']['expires']
    except subprocess.CalledProcessError as e:
        if 'CertificateNotFound' in e.stderr.decode():
            expires = None
        else:
            print(e.stderr.decode())
            raise
    if expires:
        seconds_to_expire = (datetime.datetime.strptime(expires, '%Y-%m-%dT%H:%M:%S%z') - datetime.datetime.now(datetime.timezone.utc)).total_seconds()
        days_to_expire = round(seconds_to_expire / 60 / 60 / 24)
        print(f'Certificate expires in {days_to_expire} days')
        if force:
            print('Forcing expiry due to --force argument')
        elif days_to_expire > 10:
            print('Skipping certificate renewal')
            exit(0)
        print('Renewing certificate...')
    else:
        print('Certificate not found, will create a new one')
    certbot_command = dedent(f'''
        certbot certonly -d '{root_domain},*.{root_domain}' --manual \
            --preferred-challenges dns \
            -m '{letsencrypt_email}' --agree-tos -n \
            --manual-auth-hook certbot-authenticator.py \
            --manual-cleanup-hook certbot-cleanup.py
    ''').strip()
    certs_path = f'/etc/letsencrypt/live/{root_domain}'
    if in_cluster:
        subprocess.check_call(
            certbot_command, shell=True,
            env={
                **os.environ,
                'RESOURCE_GROUP': resource_group,
            }
        )
        out_path = '.'
    else:
        certs_path = f'.data/certbot{certs_path}'
        out_path = '.data'
        os.makedirs('.data', exist_ok=True)
        pwd = getpwd()
        subprocess.check_call([
            'docker', 'build', '-t', 'certbot-uumpa-iac', 'dns'
        ])
        cmd = [
            'docker', 'run', '--rm', '--name', 'certbot',
            '-v', f'{pwd}/.data/certbot/etc/letsencrypt:/etc/letsencrypt',
            '-v', f'{pwd}/.data/certbot/var/lib/letsencrypt:/var/lib/letsencrypt',
            '-v', f'{os.environ["HOME"]}/.azure:/root/.azure',
            '-e', f'RESOURCE_GROUP={resource_group}',
            '--entrypoint', 'bash',
            'certbot-uumpa-iac', '-c',
            f'{certbot_command} && chmod -R 777 /etc/letsencrypt'
        ]
        print(' '.join(cmd))
        subprocess.check_call(cmd)
    subprocess.check_call([
        'openssl', 'pkcs12', '-export', '-in', f'{certs_path}/fullchain.pem',
        '-inkey', f'{certs_path}/privkey.pem',
        '-out', f'{out_path}/uumpa-wildcard.pfx', '-passout', 'pass:'
    ])
    subprocess.check_call([
        'az', 'keyvault', 'certificate', 'import', '--vault-name', vault_name,
        '--name', secret_name, '-f', f'{out_path}/uumpa-wildcard.pfx',
    ])
    if in_cluster:
        subprocess.check_call([
            'kubectl', 'delete', 'secret', '-n', 'ingress-nginx', 'ingress-tls-csi'
        ])
        subprocess.check_call([
            'kubectl', 'rollout', 'restart', '-n', 'ingress-nginx', 'deployment/ingress-nginx-controller'
        ])


if __name__ == '__main__':
    main(*sys.argv[1:])
