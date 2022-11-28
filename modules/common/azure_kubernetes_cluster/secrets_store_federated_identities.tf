#resource "null_resource" "set_secrets_store_federated_identities" {
#  count = length(var.secrets_store_federated_identity_service_accounts) == 0 ? 0 : (
#      var.secrets_store_federated_identities_name_prefix == "" ? 0 : 1
#  )
#  depends_on = [
#    azuread_service_principal.secretsstore[0],
#    azuread_application.secretsstore[0],
#    azurerm_kubernetes_cluster.cluster
#  ]
#  triggers = {
#    version = "1"
#    service_accounts = join(",", var.secrets_store_federated_identity_service_accounts)
#  }
#  provisioner "local-exec" {
#    command = <<EOF
#      python3 ${path.module}/bin/set_secrets_store_federated_identities.py \
#        ${azuread_application.secretsstore[0].object_id} \
#        ${azurerm_kubernetes_cluster.cluster.oidc_issuer_url} \
#        ${self.triggers.service_accounts} \
#        ${var.secrets_store_federated_identities_name_prefix}
#    EOF
#  }
#}
