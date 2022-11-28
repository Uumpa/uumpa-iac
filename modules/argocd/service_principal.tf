locals {
  service_principal_password_secret_name = "${local.core.environment_name}-argocd-automation-sp-password"
}

module "sp" {
  source = "../common/azure_service_principal"
  key_vault_name = local.core.default_key_vault.name
  name = "${local.core.environment_name}-argocd-automation-sp"
  service_principal_password_secret_name = local.service_principal_password_secret_name
}
