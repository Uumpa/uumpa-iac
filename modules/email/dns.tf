module "email_verification_dns_records_json" {
  source = "../common/external_data_command"
  script = <<-EOF
    az appconfig kv show -n ${local.uumpa_devops.default_app_configuration_name} \
      --key email-verification-dns-records-json
  EOF
}

locals {
  email_verification_dns_records = jsondecode(module.email_verification_dns_records_json.output.value)
}

resource "azurerm_dns_cname_record" "mail_verification" {
  for_each = tomap(local.email_verification_dns_records)
  name = each.key
  resource_group_name = local.core.default_resource_group.name
  ttl = 3600
  zone_name = local.dns.root_domain
  record = each.value
}
