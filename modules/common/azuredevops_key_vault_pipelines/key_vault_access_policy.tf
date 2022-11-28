resource "azurerm_key_vault_access_policy" "pol" {
  key_vault_id = var.key_vault_id
  tenant_id = var.subscription.tenant_id
  object_id = local.service_endpoint.data.spnObjectId
  secret_permissions = var.secret_permissions
}
