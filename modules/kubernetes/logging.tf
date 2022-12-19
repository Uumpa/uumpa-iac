resource "azurerm_storage_account" "logs" {
  name = "${local.core.environment_name}logs"
  resource_group_name = local.core.default_resource_group.name
  location = local.core.default_resource_group.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

#resource "azurerm_storage_container" "secure_blobs_container" {
#  name = "${var.environment_name}-secure-blobs"
#  storage_account_name = azurerm_storage_account.secure_blobs_storage.name
#}

resource "kubernetes_config_map_v1_data" "tf_outputs_logs" {
  field_manager = "terraform_kubernetes_logs"
  metadata {
    name      = "tf-outputs"
    namespace = "argocd"
  }
  data = {
    "logs_storage_account_name" = azurerm_storage_account.logs.name
    "logs_storage_account_key" = azurerm_storage_account.logs.primary_access_key
  }
}