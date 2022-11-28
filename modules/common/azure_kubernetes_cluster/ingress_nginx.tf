resource "null_resource" "deploy_ingress_nginx" {
  count = var.deploy_ingress_nginx ? 1 : 0
  depends_on = [
    azurerm_kubernetes_cluster.cluster,
    module.set_context,
    null_resource.deploy_secrets_store
  ]
  triggers = {
    version = "2"
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd} &&\
      python3 apps/ingress-nginx/deploy.py \
          ${var.tenant_id} \
          ${azuread_service_principal.secretsstore[0].application_id} \
          ${var.secretsstore_keyvault_name} \
          ${var.dns_wildcard_pfx_secret_name}
    EOF
  }
}
