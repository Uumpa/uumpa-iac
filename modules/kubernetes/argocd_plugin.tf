locals {
  argocd_plugin_version = "0.0.6"
  argocd_plugin_docker_image = "${azurerm_container_registry.default.login_server}/argocd-plugin:${local.argocd_plugin_version}"
}

resource "null_resource" "argocd_plugin_docker_build_push" {
  depends_on = [
    azurerm_container_registry.default
  ]
  triggers = {
    version = local.argocd_plugin_version
  }
  provisioner "local-exec" {
    command = <<EOF
        cd ${path.cwd} &&\
        az acr login --name ${azurerm_container_registry.default.name} &&\
        docker build -t ${local.argocd_plugin_docker_image} apps/argocd/plugin &&\
        docker push ${local.argocd_plugin_docker_image}
    EOF
  }
}
