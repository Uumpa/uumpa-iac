data "kubernetes_service" "ingress_load_balancer" {
  count = var.wildcard_dns_zone_name == "" ? 0 : 1
  depends_on = [
    null_resource.deploy_ingress_nginx,
    module.set_context,
  ]
  metadata {
    name = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

data "azurerm_public_ips" "kubernetes" {
  count = var.wildcard_dns_zone_name == "" ? 0 : 1
  depends_on = [
    null_resource.deploy_ingress_nginx,
    module.set_context,
  ]
  resource_group_name = azurerm_kubernetes_cluster.cluster.node_resource_group
  attachment_status   = "Attached"
}

locals {
  load_balancer_ip = var.wildcard_dns_zone_name == "" ? "" : data.kubernetes_service.ingress_load_balancer[0].status[0].load_balancer[0].ingress[0].ip
  matching_ingress_ip_id = var.wildcard_dns_zone_name == "" ? "" : [for ip in data.azurerm_public_ips.kubernetes[0].public_ips : ip.id if ip.ip_address == local.load_balancer_ip][0]
}

resource "azurerm_dns_a_record" "default_wildcard" {
  count = var.wildcard_dns_zone_name == "" ? 0 : 1
  name = "*"
  zone_name = var.wildcard_dns_zone_name
  resource_group_name = var.resource_group_name
  ttl = 300
  target_resource_id = local.matching_ingress_ip_id
}
