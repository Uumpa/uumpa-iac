output "dns" {
  value = {
    root_domain = local.root_domain
    letsencrypt_email = local.letsencrypt_email
    nameservers = azurerm_dns_zone.default.name_servers
    certbot_service_principal_app_id = module.certbot_role.service_principal_application_id
    wildcard_pfx_secret_name = local.wildcard_pfx_secret_name
    core = local.core
    certbot_service_principal_password_secret_name = local.certbot_service_principal_password_secret_name
  }
}
