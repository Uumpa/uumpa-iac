#!/usr/bin/env python3
import sys
import json
import subprocess


def main(environment_name, *args):
    kubernetes = json.loads(subprocess.check_output([
        'terraform', f'-chdir=environments/{environment_name}/kubernetes', 'output', '-json'
    ]).decode())['kubernetes']
    cluster_name = kubernetes['value']['cluster_name']
    subscription_id = kubernetes['value']['dns']['core']['current_subscription']['subscription_id']
    resources_group_name = kubernetes['value']['dns']['core']['default_resource_group']['name']
    subprocess.check_call([
        'python3', 'modules/common/set_kubernetes_context/bin/set_context.py', cluster_name, subscription_id, resources_group_name, *args
    ])
    print("")
    print("___________________________________________")
    print("|")
    print(f"|   Added context '{cluster_name}'")
    print("|")
    print(f"|   Next time you can run the following to switch to this context:")
    print("|")
    print(f"|        kubectl config use-context {cluster_name}")
    print("|")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("")


if __name__ == '__main__':
    main(*sys.argv[1:])
