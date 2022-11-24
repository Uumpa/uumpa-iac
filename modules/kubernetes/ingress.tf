resource "null_resource" "deploy_ingress_nginx" {
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
      python3 apps/ingress-nginx/deploy.py \
          ${var.core_resources.subscription.tenant_id} \
          ${azuread_service_principal.secretsstore.application_id} \
          ${var.core_resources.key_vault.name} \
          ${var.dns.wildcard_pfx_secret_name}
    EOF
  }
}
