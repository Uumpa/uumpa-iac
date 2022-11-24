data "kubernetes_service" "ingress_load_balancer" {
  depends_on = [
    null_resource.deploy_ingress_nginx,
    null_resource.set_kubernetes_context,
  ]
  metadata {
    name = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

data "azurerm_public_ips" "kubernetes" {
  resource_group_name = azurerm_kubernetes_cluster.default.node_resource_group
  attachment_status   = "Attached"
}

locals {
  load_balancer_ip = data.kubernetes_service.ingress_load_balancer.status[0].load_balancer[0].ingress[0].ip
  matching_ingress_ip = [for ip in data.azurerm_public_ips.kubernetes.public_ips : ip if ip.ip_address == local.load_balancer_ip][0]
}

resource "azurerm_dns_a_record" "default_wildcard" {
  name = "*"
  zone_name = var.dns.root_domain
  resource_group_name = var.core_resources.group.name
  ttl = 300
  target_resource_id = local.matching_ingress_ip.id
}
