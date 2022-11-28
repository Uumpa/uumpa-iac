output "public_key" {
  value = data.azurerm_key_vault_secret.public_key.value
}
