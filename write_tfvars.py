#!/usr/bin/env python3
import os
import json
import subprocess


AZ_ACCOUNT_NAME = 'Uumpa'
DEFAULT_ADMINS_GROUP_NAME = 'uumpa-iac terraform default admins'


def get_az_account_subscription_id_tenant_id():
    for account in json.loads(subprocess.check_output(['az', 'account', 'list'])):
        if account['name'] == AZ_ACCOUNT_NAME:
            return account['id'], account['tenantId']


def get_az_default_admins_object_ids():
    return [
        user['id'] for user
        in json.loads(subprocess.check_output([
            'az', 'ad', 'group', 'member', 'list', '--group', DEFAULT_ADMINS_GROUP_NAME
        ]))
    ]


def get_keyvault_secret(name):
    envname = 'KEYVAULT_' + name.upper().replace('-', '_')
    if os.environ.get(envname):
        return os.environ[envname]
    try:
        return subprocess.check_output([
            'az', 'keyvault', 'secret', 'download', '--name', name,
            '--vault-name', 'uumpa', '--file', '/dev/stdout'
        ]).decode()
    except:
        print(f'ERROR: {name} not found in keyvault')
        raise


def main():
    print("Fetching variable values...")
    subscription_id, tenant_id = get_az_account_subscription_id_tenant_id()
    tfvars = {
        'azurerm_subscription_id': subscription_id,
        'azuread_tenant_id': tenant_id,
        'azuread_admin_users_object_ids': get_az_default_admins_object_ids(),
        'uumpa_root_domain': get_keyvault_secret('uumpa-root-domain'),
        'admin_email': get_keyvault_secret('admin-email'),
    }
    print("Writing '.auto.tfvars.json'...")
    with open(".auto.tfvars.json", "w") as f:
        json.dump(tfvars, f, indent=2)
    print("OK")


if __name__ == "__main__":
    main()
