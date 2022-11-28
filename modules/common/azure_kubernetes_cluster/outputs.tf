output "container_registry_login_server" {
  value = azurerm_container_registry.default[0].login_server
}

output "secretstore_application_id" {
  value = azuread_application.secretsstore[0].application_id
}

output "secretstore_object_id" {
  value = azuread_application.secretsstore[0].object_id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.cluster.oidc_issuer_url
}

output "ingress_ip" {
  value = local.load_balancer_ip
}

output "ingress_ip_id" {
  value = local.matching_ingress_ip_id
}
