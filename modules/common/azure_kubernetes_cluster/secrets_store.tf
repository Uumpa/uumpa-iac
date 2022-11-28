resource "azuread_application" "secretsstore" {
  count = var.secretsstore_application_display_name == "" ? 0 : 1
  display_name = var.secretsstore_application_display_name
}

resource "azuread_service_principal" "secretsstore" {
  count = length(azuread_application.secretsstore)
  application_id = azuread_application.secretsstore[0].application_id
  app_role_assignment_required = false
}

resource "azuread_application_federated_identity_credential" "secretsstore" {
  count = var.secretsstore_federated_identity_credential_subject == "" ? 0 : 1
  application_object_id = azuread_application.secretsstore[0].object_id
  audiences             = ["api://AzureADTokenExchange"]
  display_name          = var.secretsstore_federated_identity_credential_display_name
  issuer                = azurerm_kubernetes_cluster.cluster.oidc_issuer_url
  subject               = var.secretsstore_federated_identity_credential_subject
}

resource "azurerm_key_vault_access_policy" "secretsstore" {
  count = var.secretsstore_keyvault_id == "" ? 0 : 1
  key_vault_id            = var.secretsstore_keyvault_id
  tenant_id               = var.tenant_id
  object_id               = azuread_service_principal.secretsstore[0].object_id
  certificate_permissions = ["Get"]
  key_permissions         = ["Get"]
  secret_permissions      = ["Get"]
  storage_permissions     = ["Get"]
}

resource "null_resource" "deploy_secrets_store" {
  count = var.deploy_secretsstore_app ? 1 : 0
  depends_on = [
    azurerm_kubernetes_cluster.cluster,
    module.set_context,
  ]
  triggers = {
    version = "1"
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd} &&\
      bash apps/secrets-store/deploy.sh
    EOF
  }
}
