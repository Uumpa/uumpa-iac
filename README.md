# Uumpa Infrastructure as Code

## Prerequisites

* [Terraform](https://www.terraform.io/downloads.html)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [Python 3](https://www.python.org/downloads/)
* [Azure kubelogin](https://github.com/Azure/kubelogin/blob/master/README.md)
* [Docker](https://docs.docker.com/get-docker/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/docs/intro/install/)
* Azure DevOps extension: `az extension add --name azure-devops`

## Login

Login to Azure with full access permissions: `az login --allow-no-subscriptions`

To work with Azure DevOps, create a personal access token with full access permissions and set env vars:

```
export AZDO_ORG_SERVICE_URL=https://dev.azure.com/....
export AZDO_PERSONAL_ACCESS_TOKEN=
```

## Usage

### Infrastructure

Environments are defined in `environments/` directory. Each environment has multiple sub-directories,
each corresponding to a module under `modules/`.

You can run Terraform commands for each environment/module combination using the following command:

```
bin/terraform.py ENVIRONMENT_NAME MODULE_NAME ...
```

For example:

```
bin/terraform.py ENVIRONMENT_NAME MODULE_NAME init
bin/terraform.py ENVIRONMENT_NAME MODULE_NAME plan
```

You can also run init and apply for all modules in an environment using the following command:

```
bin/terraform_init_apply.py ENVIRONMENT_NAME
```

See the help message for more options:

```
bin/terraform_init_apply.py --help
```

### Apps / ArgoCD

ArgoCD manages the apps deployments, you can add Helm apps under `apps/` directory.

Apps declared in `apps/argocd-apps/values-*.yaml` will be automatically deployed
via ArgoCD.
