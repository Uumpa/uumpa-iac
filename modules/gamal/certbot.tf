locals {
  wildcard_pfx_secret_name = "${local.core.environment_name}-gamal-wildcard-pfx"
}

module "certbot" {
  depends_on = [module.zone]
  source = "../common/certbot_wildcard"
  key_vault_name = local.core.default_key_vault.name
  letsencrypt_email = local.dns.letsencrypt_email
  resource_group_name = local.core.default_resource_group.name
  root_domain_name = local.domain_name
  wildcard_pfx_secret_name = local.wildcard_pfx_secret_name
}
