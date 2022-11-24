#!/usr/bin/env python3
import os
import time
import subprocess


def main():
    RECORD_NAME = '_acme-challenge'
    CERTBOT_DOMAIN = os.environ['CERTBOT_DOMAIN']
    CERTBOT_VALIDATION = os.environ['CERTBOT_VALIDATION']
    RESOURCE_GROUP = os.environ['RESOURCE_GROUP']
    print(f'Creating TXT record for {RECORD_NAME}.{CERTBOT_DOMAIN} with value {CERTBOT_VALIDATION}')
    subprocess.check_call([
        'az', 'network', 'dns', 'record-set', 'txt', 'add-record',
        '-g', RESOURCE_GROUP,
        '-z', CERTBOT_DOMAIN,
        '-n', RECORD_NAME,
        '-v', CERTBOT_VALIDATION
    ])
    print("Waiting 30 seconds for DNS to propagate")
    time.sleep(30)


if __name__ == '__main__':
    main()
