locals {
  deploy_saml_instructions = <<EOF

Follow this guide to setup saml authentication for ArgoCD, see notes below the link:

https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/microsoft/#azure-ad-saml-enterprise-app-auth-using-dex

* Instead of non-gallery app, select app Azure AD SAML Toolkit

Set the ssoURL in keyvault:

bin/set_secret.py ENVIRONMENT_NAME argocd-saml-ssourl https://login.microsoftonline.com/.....

Save the Certificate, assuming you downloaded the Certificate (Base64) to local file ArgoCD.cer:

bin/set_secret.py ENVIRONMENT_NAME argocd-saml-cert (cat ArgoCD.cer | base64 -w0)

EOF
}

module "check_saml_ssourl" {
  source = "../common/check_secret"
  key_vault_name = local.core.default_key_vault.name
  secret_name = "argocd-saml-ssourl"
  expected_value = ""
  instructions = local.deploy_saml_instructions
}

module "check_saml_cert" {
  depends_on = [module.check_saml_ssourl]
  source = "../common/check_secret"
  key_vault_name = local.core.default_key_vault.name
  secret_name = "argocd-saml-cert"
  expected_value = ""
  instructions = local.deploy_saml_instructions
}

module "check_azdo_token" {
  depends_on = [module.check_saml_cert]
  source = "../common/check_secret"
  key_vault_name = local.core.default_key_vault.name
  secret_name = "argocd-azdo-token"
  expected_value = ""
  instructions = <<EOF

Generate a token for Azure DevOps argocd integration:

Get the username and password:

username: ${local.uumpa_devops.azdo_user_name}
password: bin/get_secret.py ENVIRONMENT_NAME ${local.uumpa_devops.azdo_user_password_secret_name}

Go to https://dev.azure.com/uumpa/_usersSettings/tokens and login as that user

Generate a full access token with 1 year expiration

Set the token in keyvault:

bin/set_secret.py ENVIRONMENT_NAME argocd-azdo-token TOKEN

EOF
}

module "plugin_latest_image" {
  source = "../common/get_appconfig_key"
  name = local.uumpa_devops.default_app_configuration_name
  key = "argocd-plugin-latest-image"
}

locals {
  argocd_plugin_latest_image = module.plugin_latest_image.value
  deploy_argocd_command = <<-EOF
    python3 apps/argocd/deploy.py \
        ${local.dns.root_domain} \
        ${local.core.default_admins_group.object_id} \
        ${local.uumpa_devops.azuredevops_git_repository_uumpa_iac_remote_url} \
        ${local.argocd_plugin_latest_image} \
        ${local.core.default_key_vault.name}
  EOF
}

resource "null_resource" "deploy_argocd" {
  depends_on = [
    module.set_context,
    module.check_saml_ssourl,
    module.check_saml_cert,
    module.check_azdo_token
  ]
  triggers = {
    argocd_app_md5 = join(",", [for filename in fileset(path.cwd, "apps/argocd/**") : filemd5("${path.cwd}/${filename}")])
    deploy_argocd_command = local.deploy_argocd_command
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd}
      ${local.deploy_argocd_command}
    EOF
  }
}
