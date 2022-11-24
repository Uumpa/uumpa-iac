locals {
  secrets_store_federated_identity_service_accounts = [
    "cluster-admin:certbot",
  ]
}

resource "null_resource" "set_secrets_store_federated_identities" {
  depends_on = [
    azuread_service_principal.secretsstore,
    azuread_application.secretsstore,
    azurerm_kubernetes_cluster.default
  ]
  triggers = {
    version = "1"
    service_accounts = join(",", local.secrets_store_federated_identity_service_accounts)
  }
  provisioner "local-exec" {
    command = <<EOF
      python3 ${path.module}/bin/set_secrets_store_federated_identities.py \
        ${azuread_application.secretsstore.object_id} \
        ${azurerm_kubernetes_cluster.default.oidc_issuer_url} \
        ${self.triggers.service_accounts} \
        ${var.name_prefix}
    EOF
  }
}
