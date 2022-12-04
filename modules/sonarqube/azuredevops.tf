data "azuread_domains" "aad_domains" {}

locals {
  azdo_user_name = "${local.core.environment_name}-azdo-sq-integration@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  azdo_user_password_secret_name = "${local.core.environment_name}-azdo-sq-integration-user-password"
}

module "azuredevops_proj_repo_user" {
  source = "../common/azuredevops_proj_repo_user"
  group_display_name = "${local.core.environment_name} azuredevops sonarqube integration"
  key_vault_name = local.core.default_key_vault.name
  project = "uumpa"
  repository = "uumpa-iac"
  user_display_name = "${local.core.environment_name} azuredevops sonarqube integration"
  user_password_secret_name = local.azdo_user_password_secret_name
  user_principal_name = local.azdo_user_name
  azuredevops_token_secret_name = "sonarqube-azdo-token"
}
