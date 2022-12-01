#!/usr/bin/env python3
import os
import json
import subprocess


ARGOCD_TOKEN = os.environ.get('ARGOCD_TOKEN')
ARGOCD_DOMAIN = os.environ.get('ARGOCD_DOMAIN')


def main():
    print("Getting apps list")
    for app in json.loads(subprocess.check_output([
        'curl', '-sH', f'Authorization: Bearer {ARGOCD_TOKEN}',
        f"https://{ARGOCD_DOMAIN}/api/v1/applications"
    ]))['items']:
        app_name = app['metadata']['name']
        print(f'Refreshing {app_name}')
        subprocess.check_output([
            'curl', '-sH', f'Authorization: Bearer {ARGOCD_TOKEN}',
            f"https://{ARGOCD_DOMAIN}/api/v1/applications/{app_name}?refresh=hard"
        ])
    print('OK')


if __name__ == '__main__':
    main()