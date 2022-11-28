output "core" {
  value = {
    current_subscription = data.azurerm_subscription.current
    default_admins_group = azuread_group.default_admins
    first_admin = azuread_group_member.first_admin
    default_key_vault = azurerm_key_vault.default
    default_resource_group = azurerm_resource_group.default
    environment_name = var.environment_name
    default_location = var.default_location
  }
}
