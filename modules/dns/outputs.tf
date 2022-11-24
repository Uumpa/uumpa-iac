output "dns" {
  value = {
    nameservers = azurerm_dns_zone.default.name_servers
    root_domain = local.root_domain
    letsencrypt_email = local.letsencrypt_email
    certbot_service_principal_app_id = data.azuread_service_principal.certbot.application_id
    wildcard_pfx_secret_name = local.wildcard_pfx_secret_name
  }
}
