data "azuread_domains" "aad_domains" {}

locals {
  azdo_user_name = "uumpa-azuredevops-automation@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  azdo_user_password_secret_name = "uumpa-azuredevops-automation-user-password"
}

module "azuredevops_proj_repo_user" {
  source = "../common/azuredevops_proj_repo_user"
  group_display_name = "uumpa azuredevops automation"
  key_vault_name = local.core.default_key_vault.name
  project = "uumpa"
  repository = "uumpa-iac"
  user_display_name = "uumpa azuredevops automation"
  user_password_secret_name = local.azdo_user_password_secret_name
  user_principal_name = local.azdo_user_name
}
