#!/usr/bin/env python3
import json
import subprocess


def get_terraform_output():
    return json.loads(subprocess.check_output(['terraform', 'output', '-json']).decode())


def main():
    terraform_output = get_terraform_output()
    subprocess.run(['kubectl', 'apply', '-n', 'argocd', '-f', '-'], check=True, input=json.dumps({
        'apiVersion': 'v1',
        'kind': 'ConfigMap',
        'metadata': {
            'name': 'tf-outputs',
        },
        'data': {
            # values from terraform output which have the same key as the configmap key
            **{
                k: terraform_output[k]['value']
                for k in [
                    'tenant_id',
                    'certbot_service_principal_app_id',
                    'uumpa_root_domain',
                    'admin_email',
                    'dns_certbot_docker_image',
                ]
            },
            # values from terraform output which have a different key than the configmap key
            **{
                k: terraform_output[v]['value']
                for k, v in {
                    'secrets_provider_client_id': 'service_principal_uumpa_kubernetes_keyvault_application_id',

                }.items()
            }
        }
    }).encode())


if __name__ == '__main__':
    main()
