#!/usr/bin/env python3
import os
import sys
import subprocess


def check_call(*args, **kwargs):
    try:
        subprocess.check_call(*args, **kwargs)
    except subprocess.CalledProcessError as e:
        exit(e.returncode)


def main(environment_name, path, command, *args):
    no_backend_config = '--no-backend-config' in args
    args = [arg for arg in args if arg != '--no-backend-config']
    path = os.path.join('environments', environment_name, path)
    default_resourcegroup_name = f'{environment_name}-default'
    secure_blobs_storage_account_name = f'{environment_name}secureblobs'
    secure_blobs_container_name = f'{environment_name}-secure-blobs'
    path_id = path.strip().strip('/').replace('/', '.')
    backend_key = f'terraform.tfstate.{path_id}'
    backend_key_prefix = f'terraform.tfstate.environments.{environment_name}'
    if command == 'init':
        check_call([
            'terraform', f'-chdir={path}', 'init',
            *([f'-backend-config=resource_group_name={default_resourcegroup_name}',
            f'-backend-config=storage_account_name={secure_blobs_storage_account_name}',
            f'-backend-config=container_name={secure_blobs_container_name}',
            f'-backend-config=key={backend_key}'] if not no_backend_config else []),
            *args
        ])
    elif command in ['plan', 'apply', 'destroy', 'refresh']:
        check_call([
            'terraform', f'-chdir={path}', command,
            f'-var=environment_name={environment_name}',
            f'-var=default_resourcegroup_name={default_resourcegroup_name}',
            f'-var=secure_blobs_storage_account_name={secure_blobs_storage_account_name}',
            f'-var=secure_blobs_container_name={secure_blobs_container_name}',
            f'-var=backend_key_prefix={backend_key_prefix}',
            *args
        ])
    else:
        check_call(['terraform', f'-chdir={path}', command, *args])


if __name__ == '__main__':
    main(*sys.argv[1:])
