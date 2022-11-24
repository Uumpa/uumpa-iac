resource "azurerm_container_registry" "default" {
  location = azurerm_kubernetes_cluster.default.location
  name = var.name_prefix
  resource_group_name = var.core_resources.group.name
  sku = "Basic"
}

resource "azurerm_role_assignment" "default_kubernetes_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.default.id
  skip_service_principal_aad_check = true
}
