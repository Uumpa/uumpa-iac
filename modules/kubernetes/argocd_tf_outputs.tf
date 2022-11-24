resource "kubernetes_config_map" "argocd_tf_outputs" {
  depends_on = [
    null_resource.deploy_argocd
  ]
  metadata {
    name      = "tf-outputs"
    namespace = "argocd"
  }
  data = {
    tenant_id = var.core_resources.subscription.tenant_id
    certbot_service_principal_app_id = var.dns.certbot_service_principal_app_id
    uumpa_root_domain = var.dns.root_domain
    admin_email = var.dns.letsencrypt_email
    dns_certbot_docker_image = local.dns_certbot_docker_image
    secrets_provider_client_id = azuread_service_principal.secretsstore.application_id
  }
}
