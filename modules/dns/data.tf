data "azurerm_key_vault_secret" "root_domain" {
  name = "root-domain"
  key_vault_id = local.core.default_key_vault.id
}

data "azurerm_key_vault_secret" "letsencrypt_email" {
  name = "letsencrypt-email"
  key_vault_id = local.core.default_key_vault.id
}

locals {
  root_domain = nonsensitive(data.azurerm_key_vault_secret.root_domain.value)
  letsencrypt_email = nonsensitive(data.azurerm_key_vault_secret.letsencrypt_email.value)
}
