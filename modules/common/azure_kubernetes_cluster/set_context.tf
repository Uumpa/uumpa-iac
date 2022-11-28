module "set_context" {
  depends_on = [azurerm_kubernetes_cluster.cluster]
  source = "../set_kubernetes_context"
  cluster_name = azurerm_kubernetes_cluster.cluster.name
  resource_group_name = var.resource_group_name
  subscription_id = var.subscription_id
}
