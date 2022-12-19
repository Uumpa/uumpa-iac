resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  kubernetes_cluster_id = module.cluster.kubernetes_cluster_id
  name = "extra"
  vm_size = "Standard_B2s"
  node_count          = 0
  enable_auto_scaling = true
  min_count           = 0
  max_count           = 3
  os_disk_type        = "Managed"
  os_disk_size_gb     = 100
  os_sku              = "Ubuntu"
}
