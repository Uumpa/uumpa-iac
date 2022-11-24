resource "azurerm_storage_account" "secure_blob_storage" {
  name = "${var.name_prefix}secureblobs"
  resource_group_name = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location
  account_kind = "BlobStorage"
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "secure_blobs_container" {
  name = "${var.name_prefix}-secure-blobs"
  storage_account_name = azurerm_storage_account.secure_blob_storage.name
}
