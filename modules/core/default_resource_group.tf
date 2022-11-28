resource "azurerm_resource_group" "default" {
  name = "${var.environment_name}-default"
  location = var.default_location
}
