locals {
  default_cluster_name = var.name_prefix
  default_cluster_dns_prefix = var.name_prefix
  default_cluster_kubernetes_version = "1.23.12"
}

resource "azuread_group" "default_kubernetes_admins" {
  display_name     = "${var.name_prefix} Default Kubernetes Admins"
  owners           = var.core_resources.admins.members
  members          = var.core_resources.admins.members
  security_enabled = true
}

resource "azurerm_kubernetes_cluster" "default" {
  name                   = local.default_cluster_name
  location               = var.location
  resource_group_name    = var.core_resources.group.name
  dns_prefix             = local.default_cluster_dns_prefix
  kubernetes_version     = local.default_cluster_kubernetes_version
  local_account_disabled = true
  oidc_issuer_enabled    = true

  default_node_pool {
    name                = "default"
    # 2vCPU, 8GB RAM, 0GB temporary storage, $0.115/hour ($83.95/month)
    vm_size             = "Standard_D2s_v4"
    node_count          = 1
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
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
    admin_group_object_ids = [azuread_group.default_kubernetes_admins.object_id]
  }
}

