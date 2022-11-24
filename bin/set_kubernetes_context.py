#!/usr/bin/env python3
import sys
import subprocess
from textwrap import dedent


def check_if_context_exists(cluster_name):
    return cluster_name in [
        l.strip() for l
        in subprocess.check_output(['kubectl', 'config', 'get-contexts', '-o', 'name']).decode().splitlines()
        if l.strip()
    ]


def main(cluster_name, subscription_id, resource_group_name, *args):
    skip_if_context_exists = '--skip-if-context-exists' in args
    if skip_if_context_exists and check_if_context_exists(cluster_name):
        subprocess.check_call(['kubectl', 'config', 'use-context', cluster_name])
        return
    print(f"Setting {cluster_name} Kubernetes context...")
    subprocess.check_call(dedent(f"""
        az account set --subscription "{subscription_id}" &&\
        az aks get-credentials --resource-group "{resource_group_name}" \
          --name "{cluster_name}" --overwrite-existing &&\
        kubelogin convert-kubeconfig -l azurecli
    """), shell=True)
    print("Setting default context and running kubectl get nodes to test connection...")
    subprocess.check_call(dedent(f"""
        kubectl config use-context "{cluster_name}" &&\
        kubectl get nodes
    """), shell=True)


if __name__ == '__main__':
    main(*sys.argv[1:])
