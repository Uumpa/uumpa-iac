output "kubernetes" {
  value = {
    dns = local.dns
    container_registry_name = local.container_registry_name
    container_registry_login_server = module.cluster.container_registry_login_server
    cluster_name = local.cluster_name
    secretstore_object_id = module.cluster.secretstore_object_id
    secretstore_application_id = module.cluster.secretstore_application_id
    oidc_issuer_url = module.cluster.oidc_issuer_url
    ingress_ip = module.cluster.ingress_ip
    ingress_ip_id = module.cluster.ingress_ip_id
  }
}
