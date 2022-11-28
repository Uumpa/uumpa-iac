locals {
  certbot_service_principal_password_secret_name = "${local.core.environment_name}-certbot-automation-service-principal-password"
}

module "certbot_role" {
  source = "../common/azure_service_principal_role_keyvault"
  key_vault_certificate_permissions = ["Create", "Delete", "Get", "Import", "List", "Update"]
  key_vault_id = local.core.default_key_vault.id
  key_vault_name = local.core.default_key_vault.name
  name = "${local.core.environment_name}-certbot-automation"
  permissions_actions = [
    "Microsoft.Network/dnszones/read",
    "Microsoft.Network/dnszones/TXT/read",
    "Microsoft.Network/dnszones/TXT/write",
    "Microsoft.Network/dnszones/TXT/delete",
  ]
  scope = "/subscriptions/${local.core.current_subscription.subscription_id}"
  service_principal_password_secret_name = local.certbot_service_principal_password_secret_name
  subscription_id = local.core.current_subscription.subscription_id
  tenant_id = local.core.current_subscription.tenant_id
}
