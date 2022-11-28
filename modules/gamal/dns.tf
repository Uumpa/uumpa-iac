resource "azurerm_dns_a_record" "gamal_wildcard" {
  name = "*"
  zone_name = local.domain_name
  resource_group_name = local.core.default_resource_group.name
  ttl = 300
  target_resource_id = local.kubernetes.ingress_ip_id
}

resource "azurerm_dns_a_record" "gamal_root" {
  name = "@"
  zone_name = local.domain_name
  resource_group_name = local.core.default_resource_group.name
  ttl = 300
  target_resource_id = local.kubernetes.ingress_ip_id
}
