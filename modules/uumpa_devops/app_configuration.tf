resource "azurerm_app_configuration" "default" {
  name = "${local.core.environment_name}-default"
  resource_group_name = local.core.default_resource_group.name
  location = local.core.default_resource_group.location
}

resource "azurerm_role_assignment" "default_app_configuration_reader_writer" {
  principal_id = local.service_endpoints[0].data.spnObjectId
  role_definition_name = "App Configuration Data Owner"
  scope = azurerm_app_configuration.default.id
  skip_service_principal_aad_check = true
}
