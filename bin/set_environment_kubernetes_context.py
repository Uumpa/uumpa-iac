#!/usr/bin/env python3
import sys
import json
import subprocess


def main(environment_name):
    core = json.loads(subprocess.check_output([
        'terraform', f'-chdir=environments/{environment_name}/core', 'output', '-json'
    ]).decode())
    context_name = core['name_prefix']['value']
    subscription_id = core['core_resources']['value']['subscription']['subscription_id']
    resources_group_name = core['core_resources']['value']['group']['name']
    subprocess.check_call([
        'python3', 'bin/set_kubernetes_context.py', context_name, subscription_id, resources_group_name
    ])
    print("")
    print("___________________________________________")
    print("|")
    print(f"|   Added context '{context_name}'")
    print("|")
    print(f"|   Next time you can run the following to switch to this context:")
    print("|")
    print(f"|        kubectl config use-context {context_name}")
    print("|")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("")


if __name__ == '__main__':
    main(*sys.argv[1:])
