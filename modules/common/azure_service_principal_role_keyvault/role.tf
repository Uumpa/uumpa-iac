resource "azurerm_role_definition" "rd" {
  name  = var.name
  scope = var.scope
  permissions {
    actions = var.permissions_actions
  }
}
