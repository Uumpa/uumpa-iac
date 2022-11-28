resource "azuread_application_federated_identity_credential" "cluster_admin_certbot" {
  application_object_id = module.cluster.secretstore_object_id
  audiences = ["api://AzureADTokenExchange"]
  display_name = "${local.core.environment_name}_kubernetes_secretsstore_cluster_admin_certbot"
  issuer = module.cluster.oidc_issuer_url
  subject = "system:serviceaccount:cluster-admin:certbot"
}
