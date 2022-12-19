resource "azurerm_kubernetes_cluster" "cluster" {
  name                   = var.cluster_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  dns_prefix             = var.dns_prefix
  kubernetes_version     = var.kubernetes_version
  local_account_disabled = true
  oidc_issuer_enabled    = true

  default_node_pool {
    name                = "default"
    # 2vCPU, 8GB RAM, 0GB temporary storage, $0.115/hour ($83.95/month)
    vm_size             = "Standard_D2s_v4"
    node_count          = 1
    enable_auto_scaling = false
    os_disk_type        = "Managed"
    os_disk_size_gb     = 200
    os_sku              = "Ubuntu"
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.admins.object_id]
  }
}
