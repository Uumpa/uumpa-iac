locals {
  domain_name = "gam.al"
}

module "zone" {
  source = "../common/azure_zone_nameservers"
  domain_name = local.domain_name
  resource_group_name = local.core.default_resource_group.name
}
