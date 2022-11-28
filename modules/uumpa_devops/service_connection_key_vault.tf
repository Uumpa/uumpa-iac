resource "azurerm_key_vault_access_policy" "pol" {
  count = length(local.service_endpoints) == 1 ? 1 : 0
  key_vault_id = local.core.default_key_vault.id
  tenant_id = local.core.current_subscription.tenant_id
  object_id = local.service_endpoints[0].data.spnObjectId
  secret_permissions = [
    "Get",
    "List"
  ]
}
