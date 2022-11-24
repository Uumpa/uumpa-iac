#!/usr/bin/env python3
import sys
import json
import subprocess


def main(tenant_id, client_id, keyvault_name, wildcard_pfx_secret_name):
    print("Deploying Nginx Ingress...")
    if subprocess.call(['kubectl', 'get', 'ns', 'ingress-nginx']) != 0:
        subprocess.check_call(['kubectl', 'create', 'ns', 'ingress-nginx'])
    subprocess.run(
        ['kubectl', 'apply', '-n', 'ingress-nginx', '-f', '-'],
        check=True,
        input=json.dumps({
            "apiVersion": "secrets-store.csi.x-k8s.io/v1",
            "kind": "SecretProviderClass",
            "metadata": {
                "name": "azure-tls",
                "namespace": "ingress-nginx",
            },
            "spec": {
                "parameters": {
                    "clientID": client_id,
                    "keyvaultName": keyvault_name,
                    "objects": f"array:\n  - |\n    objectName: {wildcard_pfx_secret_name}\n    objectType: secret\n",
                    "tenantID": tenant_id
                },
                "provider": "azure",
                "secretObjects": [
                    {
                        "data": [
                            {
                                "key": "tls.key",
                                "objectName": wildcard_pfx_secret_name
                            },
                            {
                                "key": "tls.crt",
                                "objectName": wildcard_pfx_secret_name
                            }
                        ],
                        "secretName": "ingress-tls-csi",
                        "type": "kubernetes.io/tls"
                    }
                ]
            }
        }).encode()
    )
    subprocess.check_call(['kubectl', 'apply', '-n', 'ingress-nginx', '-k', 'apps/ingress-nginx'])
    print("OK")


if __name__ == '__main__':
    main(*sys.argv[1:])
