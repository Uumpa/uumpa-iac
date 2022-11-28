resource "azurerm_storage_account" "secure_blobs_storage" {
  name = "${var.environment_name}secureblobs"
  resource_group_name = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
  account_kind = "BlobStorage"
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "secure_blobs_container" {
  name = "${var.environment_name}-secure-blobs"
  storage_account_name = azurerm_storage_account.secure_blobs_storage.name
}
