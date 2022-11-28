resource "azurerm_container_registry" "default" {
  count = var.container_registry_name == "" ? 0 : 1
  location = azurerm_kubernetes_cluster.cluster.location
  name = var.container_registry_name
  resource_group_name = var.resource_group_name
  sku = "Basic"
}

resource "azurerm_role_assignment" "acr_pull" {
  count = length(azurerm_container_registry.default)
  principal_id = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope = azurerm_container_registry.default[0].id
  skip_service_principal_aad_check = true
}
