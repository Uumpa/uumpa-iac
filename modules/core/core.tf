resource "azurerm_resource_group" "default" {
  name = "${var.name_prefix}-default"
  location = var.location
}

# this group has to be created manually
# you should add at least yourself to this group
data "azuread_group" "default_admins" {
  display_name = "${var.name_prefix} terraform default admins"
}

data "azurerm_subscription" "current" {}
