resource "kubernetes_config_map" "tf_outputs" {
  depends_on = [
    null_resource.deploy_argocd
  ]
  metadata {
    name      = "tf-outputs"
    namespace = "argocd"
  }
}

resource "kubernetes_config_map_v1_data" "tf_outputs" {
  depends_on = [
    kubernetes_config_map.tf_outputs
  ]
  field_manager = "terraform_module_argocd"
  metadata {
    name      = "tf-outputs"
    namespace = "argocd"
  }
  data = {
    tenant_id = local.core.current_subscription.tenant_id
    certbot_service_principal_app_id = local.dns.certbot_service_principal_app_id
    uumpa_root_domain = local.dns.root_domain
    admin_email = local.dns.letsencrypt_email
    secrets_provider_client_id = local.kubernetes.secretstore_application_id
    argocd_service_principal_app_id = module.sp.service_principal_application_id
    appconfig_endpoint = local.uumpa_devops.default_app_configuration_endpoint
    wildcard_pfx_secret_name = local.dns.wildcard_pfx_secret_name
    certbot_service_principal_password_secret_name = local.dns.certbot_service_principal_password_secret_name
    keyvault_name = local.core.default_key_vault.name
  }
}
