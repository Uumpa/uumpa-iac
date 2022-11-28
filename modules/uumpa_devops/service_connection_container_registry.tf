data "azurerm_container_registry" "default" {
  name = local.kubernetes.container_registry_name
  resource_group_name = local.core.default_resource_group.name
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id = local.service_endpoints[0].data.spnObjectId
  role_definition_name = "AcrPull"
  scope = data.azurerm_container_registry.default.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "acr_push" {
  principal_id = local.service_endpoints[0].data.spnObjectId
  role_definition_name = "AcrPush"
  scope = data.azurerm_container_registry.default.id
  skip_service_principal_aad_check = true
}
