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

* Login to Azure with full access permissions: `az login --allow-no-subscriptions`
* Create an Azure Devops personal access token with full access permissions to relevant project and set environment variables:
```
export AZDO_ORG_SERVICE_URL=https://dev.azure.com/....
export AZDO_PERSONAL_ACCESS_TOKEN=
```

## Usage

### Infrastructure / Terraform

Terraform is used to deploy infrastructure changes

### Deploy Infrastructure Changes

Deploy changes:

```
terraform -chdir=environments/ENVIRONMENT_NAME/MODULE_NAME init
terraform -chdir=environments/ENVIRONMENT_NAME/MODULE_NAME apply
```

### Implement Infrastructure Changes

Infrastructure changes should be implemented in the following files:

* `modules/MODULE_NAME/*.tf` - Terraform shared module - used by multiple environments
  * `modules/MODULE_NAME/module.config.json` - Configuration for the environments which use this module
  * `modules/MODULE_NAME/module.tf.template` - Terraform configuration template for the environments which use this module
* `environments/ENVIRONMENT_NAME/MODULE_NAME/*.tf` - Terraform environment module - used only by the specific environment
* `environments/ENVIRONMENT_NAME/config.json` - Configuration for the environment

If you make changes to the environment / module config or template, you should run the following
command to update the environment terraform configuration accordingly:

```
bin/update_terraform_environment_module.py ENVIRONMENT_NAME MODULE_NAME
```

### Apps / ArgoCD

ArgoCD manages the apps deployments, you can add Helm apps under `apps/` directory.

Apps declared in `apps/argocd-apps/values-*.yaml` will be automatically deployed
via ArgoCD.
