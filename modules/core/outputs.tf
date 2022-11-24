output "name_prefix" {
  value = var.name_prefix
}

output "core_resources" {
  value = {
    group = azurerm_resource_group.default
    admins = data.azuread_group.default_admins
    subscription = data.azurerm_subscription.current
    key_vault = azurerm_key_vault.default
    name_prefix = var.name_prefix
  }
}
