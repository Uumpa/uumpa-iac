data "azurerm_key_vault_secret" "root_domain" {
  name = "root-domain"
  key_vault_id = var.core_resources.key_vault.id
}

data "azurerm_key_vault_secret" "letsencrypt_email" {
  name = "letsencrypt-email"
  key_vault_id = var.core_resources.key_vault.id
}

locals {
  root_domain = nonsensitive(data.azurerm_key_vault_secret.root_domain.value)
  letsencrypt_email = nonsensitive(data.azurerm_key_vault_secret.letsencrypt_email.value)
}

resource "azurerm_dns_zone" "default" {
  name                = local.root_domain
  resource_group_name = var.core_resources.group.name
}

resource "null_resource" "check_dns_name_servers" {
  triggers = {
    version          = 1
    dns_name_servers = join(",", azurerm_dns_zone.default.name_servers)
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/bin/check_name_servers.sh ${local.root_domain} ${join(" ", azurerm_dns_zone.default.name_servers)}"
  }
}
