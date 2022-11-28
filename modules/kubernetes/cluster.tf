locals {
  cluster_name = "${local.core.environment_name}-default"
  container_registry_name = "${local.core.environment_name}default"
}

module "cluster" {
  source = "../common/azure_kubernetes_cluster"
  admins_group_display_name = "${local.core.environment_name} Default Kubernetes Admins"
  cluster_name = local.cluster_name
  dns_prefix = "${local.core.environment_name}-default"
  first_admin_member_object_id = local.core.first_admin.member_object_id
  kubernetes_version = "1.23.12"
  location = local.core.default_resource_group.location
  resource_group_name = local.core.default_resource_group.name
  container_registry_name = local.container_registry_name
  subscription_id = local.core.current_subscription.subscription_id
  secretsstore_application_display_name = "${local.core.environment_name} Default Kubernetes Secrets Store"
  secretsstore_federated_identity_credential_display_name = "${local.core.environment_name}_kubernetes_secretsstore_ingress_nginx"
  secretsstore_federated_identity_credential_subject = "system:serviceaccount:ingress-nginx:ingress-nginx"
  secretsstore_keyvault_id = local.core.default_key_vault.id
  secretsstore_keyvault_name = local.core.default_key_vault.name
  tenant_id = local.core.current_subscription.tenant_id
  dns_wildcard_pfx_secret_name = local.dns.wildcard_pfx_secret_name
  wildcard_dns_zone_name = local.dns.root_domain
  secrets_store_federated_identity_service_accounts = [
    "cluster-admin:certbot",
  ]
  secrets_store_federated_identities_name_prefix = local.core.environment_name
}
