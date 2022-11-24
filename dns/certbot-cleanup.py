#!/usr/bin/env python3
import os
import subprocess


def main():
    RECORD_NAME = '_acme-challenge'
    CERTBOT_DOMAIN = os.environ['CERTBOT_DOMAIN']
    RESOURCE_GROUP = os.environ['RESOURCE_GROUP']
    print(f'Deleting TXT record {RECORD_NAME}.{CERTBOT_DOMAIN}')
    subprocess.check_call([
        'az', 'network', 'dns', 'record-set', 'txt', 'delete',
        '-g', RESOURCE_GROUP,
        '-z', CERTBOT_DOMAIN,
        '-n', RECORD_NAME,
        '-y'
    ])


if __name__ == '__main__':
    main()
