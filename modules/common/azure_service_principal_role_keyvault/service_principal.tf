module "sp" {
  source = "../azure_service_principal"
  key_vault_name = var.key_vault_name
  name = var.name
  service_principal_password_secret_name = var.service_principal_password_secret_name
  scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
  role = var.name
}