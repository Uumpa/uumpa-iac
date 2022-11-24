# Bootstrap

This document describes how to create a new environment from scratch.

Prerequisites:

* Create an Azure account / tenant / subscription.
* Create an Azure DevOps organization with project `uumpa` and repo `uumpa-iac` containing this repo.
* Follow the [README](../README.md) prerequisites and login steps.

Create the environment directory and config under `environments/NAME/config.json` 
you can copy the `config.json` from another environment and change the values.

Set the environment name in env var to be used in following commands:

```
ENVIRONMENT_NAME=NAME
```

Create the `core` module with local backend:

```
bin/update_terraform_environment_module.py $ENVIRONMENT_NAME core --local-backend
```

Deploy the `core` module:

```
terraform -chdir=environments/$ENVIRONMENT_NAME/core init &&\
terraform -chdir=environments/$ENVIRONMENT_NAME/core apply
```

This will create the storage account and container for the remote backend.
So you can switch to remote backend now:

```
bin/update_terraform_environment_module.py $ENVIRONMENT_NAME core
terraform -chdir=environments/$ENVIRONMENT_NAME/core init -migrate-state
```

If you deploy now it should use the remote backend:

```
terraform -chdir=environments/$ENVIRONMENT_NAME/core apply
```

You can delete the local state files:

```
rm environments/$ENVIRONMENT_NAME/core/terraform.tfstate*
```

Set key vault secrets (set appropriate values):

```
bin/set_environment_secret.py test root-domain DOMAIN
bin/set_environment_secret.py test letsencrypt-email EMAIL
```

Deploy the dns module:

```
bin/update_terraform_environment_module.py $ENVIRONMENT_NAME dns
terraform -chdir=environments/$ENVIRONMENT_NAME/dns init
terraform -chdir=environments/$ENVIRONMENT_NAME/dns apply
```

It will fail due to missing nameservers, run the following to get the list of nameservers:

```
terraform -chdir=environments/$ENVIRONMENT_NAME/dns output
```

Once the nameservers are set, run the following to deploy the dns module again:

```
terraform -chdir=environments/$ENVIRONMENT_NAME/dns apply
```

Deploy the kubernetes module:

```
bin/update_terraform_environment_module.py $ENVIRONMENT_NAME kubernetes
terraform -chdir=environments/$ENVIRONMENT_NAME/kubernetes init
terraform -chdir=environments/$ENVIRONMENT_NAME/kubernetes apply
```

Some steps will fail and will succeed after a while, 
some steps require the following manual steps to succeed:

Follow this guide to setup saml authentication for ArgoCD, see notes below the link:

https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/microsoft/#azure-ad-saml-enterprise-app-auth-using-dex

* Instead of "non-gallery app", select app "Azure AD SAML Toolkit"

Set the ssoURL in keyvault:

```
bin/set_environment_secret.py $ENVIRONMENT_NAME argocd-saml-ssourl https://login.microsoftonline.com/.....
```

Save the Certificate, assuming you downloaded the Certificate (Base64) to local file `Argo CD.cer`:

```
bin/set_environment_secret.py $ENVIRONMENT_NAME argocd-saml-cert "$(cat Argo\ CD.cer | base64 -w0)"
```

Generate a token for for Azure DevOps argocd integration:

* Get the username and password:
  * username: `terraform -chdir=environments/$ENVIRONMENT_NAME/kubernetes output argocd_integration_username`
  * password: `bin/get_environment_secret.py $ENVIRONMENT_NAME $(terraform -chdir=environments/$ENVIRONMENT_NAME/kubernetes output -raw argocd_integration_password_secret_name)`
* Go to https://dev.azure.com/uumpa/_usersSettings/tokens and login as that user
* Generate a full access token with 1 year expiration
* Set the token in keyvault:
  * `bin/set_environment_secret.py $ENVIRONMENT_NAME argocd-azdo-token TOKEN`

After everything completes successfully, you can verify that argocd is available at https://argocd.ROOT_DOMAIN

You should also verify in Argo CD that the cluster-admin app is deployed and synced correctly.
