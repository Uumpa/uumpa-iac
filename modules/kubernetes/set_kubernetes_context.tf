resource "null_resource" "set_kubernetes_context" {
  depends_on = [
    azurerm_kubernetes_cluster.default
  ]
  triggers = {
    timestamp = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd} &&\
      python3 bin/set_kubernetes_context.py \
        ${azurerm_kubernetes_cluster.default.name} \
        ${var.core_resources.subscription.subscription_id} \
        ${var.core_resources.group.name} \
        --skip-if-context-exists
    EOF
  }
}
