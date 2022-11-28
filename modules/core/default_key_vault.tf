resource "azurerm_key_vault" "default" {
  name = "${var.environment_name}-default"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tenant_id = data.azurerm_subscription.current.tenant_id
  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "first_admin" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id = data.azuread_client_config.current.tenant_id
  object_id = data.azuread_client_config.current.object_id
  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers",
    "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
  ]
  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover",
    "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey",
    "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
  storage_permissions = [
    "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey",
    "Restore", "Set", "SetSAS", "Update"
  ]
  lifecycle {
    ignore_changes = all
  }
}
