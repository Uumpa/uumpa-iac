resource "azuread_application_federated_identity_credential" "gamal" {
  application_object_id = local.kubernetes.secretstore_object_id
  audiences = ["api://AzureADTokenExchange"]
  display_name = "${local.core.environment_name}_kubernetes_secretsstore_gamal"
  issuer = local.kubernetes.oidc_issuer_url
  subject = "system:serviceaccount:gamal:gamal"
}
