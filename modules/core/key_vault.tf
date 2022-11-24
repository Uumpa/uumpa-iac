resource "azurerm_key_vault" "default" {
  name = "${var.name_prefix}-default"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tenant_id = data.azurerm_subscription.current.tenant_id
  sku_name = "standard"
}

resource "azuread_group" "default_key_vault_admins" {
  display_name = "${var.name_prefix} key vault admins"
  owners = data.azuread_group.default_admins.members
  members = data.azuread_group.default_admins.members
  security_enabled = true
}

resource "azurerm_key_vault_access_policy" "default_admins" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id = azurerm_key_vault.default.tenant_id
  object_id = azuread_group.default_key_vault_admins.object_id
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
}
