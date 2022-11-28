# Bootstrap

This document describes how to create a new environment from scratch.

Set environment name in env var to be used in following commands. The name must be only lowercase
letters:

```
ENVIRONMENT_NAME=
```

Prerequisites:

* Create an Azure account / tenant / subscription.
* Create an Azure DevOps organization with project `uumpa` and repo `uumpa-iac` containing this repo.
* Follow the [README](../README.md) prerequisites and login steps.

Duplicate an existing environment directory to directory `environments/$ENVIRONMENT_NAME`

Delete all .terraform subdirectories:

```
find environments/$ENVIRONMENT_NAME -type d -name .terraform | xargs rm -rf
```

Edit `environments/$ENVIRONMENT_NAME/core/main.tf`:

* change the backend to `local`
* change any other variables / configurations as needed for your environment

Deploy using local backend:

```
bin/terraform.py $ENVIRONMENT_NAME core init --no-backend-config
bin/terraform.py $ENVIRONMENT_NAME core apply --no-backend-config
```

Edit `environments/$ENVIRONMENT_NAME/core/main.tf`, change backend to `azurerm`

Migrate to the new backend:

```
bin/terraform.py $ENVIRONMENT_NAME core init -migrate-state
bin/terraform.py $ENVIRONMENT_NAME core apply
```

Delete the local state files:

```
rm environments/$ENVIRONMENT_NAME/core/terraform.tfstate*
```

Set key vault secrets with appropriate values for the environment:

```
bin/set_secret.py $ENVIRONMENT_NAME root-domain DOMAIN
bin/set_secret.py $ENVIRONMENT_NAME letsencrypt-email EMAIL
```

Deploy all the modules in order:

```
bin/terraform_init_apply.py $ENVIRONMENT_NAME
```

Some steps will fail and will succeed after a while, 
some steps will require manual steps, see error messages.
