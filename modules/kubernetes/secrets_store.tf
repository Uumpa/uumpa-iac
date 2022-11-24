resource "azuread_application" "secretsstore" {
  display_name = "${var.name_prefix} kubernetes secretsstore"
}

resource "azuread_service_principal" "secretsstore" {
  application_id = azuread_application.secretsstore.application_id
  app_role_assignment_required = false
}

resource "azuread_application_federated_identity_credential" "secretsstore" {
  application_object_id = azuread_application.secretsstore.object_id
  audiences             = ["api://AzureADTokenExchange"]
  display_name          = "${var.name_prefix}_kubernetes_secretsstore"
  issuer                = azurerm_kubernetes_cluster.default.oidc_issuer_url
  subject               = "system:serviceaccount:ingress-nginx:ingress-nginx"
}

resource "azurerm_key_vault_access_policy" "uumpa_kubernetes" {
  key_vault_id            = var.core_resources.key_vault.id
  tenant_id               = var.core_resources.subscription.tenant_id
  object_id               = azuread_service_principal.secretsstore.object_id
  certificate_permissions = ["Get"]
  key_permissions         = ["Get"]
  secret_permissions      = ["Get"]
  storage_permissions     = ["Get"]
}

resource "null_resource" "deploy_secrets_store" {
  depends_on = [
    azurerm_kubernetes_cluster.default,
    null_resource.set_kubernetes_context,
  ]
  triggers = {
    version = "2"
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd} &&\
      bash apps/secrets-store/deploy.sh
    EOF
  }
}
