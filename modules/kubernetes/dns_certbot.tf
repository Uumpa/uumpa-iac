locals {
  dns_certbot_version      = "0.0.4"
  dns_certbot_docker_image = "${azurerm_container_registry.default.login_server}/dns-certbot:${local.dns_certbot_version}"
}

resource "null_resource" "dns_certbot_docker_build_push" {
  depends_on = [
    azurerm_container_registry.default
  ]
  triggers = {
    version = local.dns_certbot_version
  }
  provisioner "local-exec" {
    command = <<EOF
        cd ${path.cwd} &&\
        az acr login --name ${azurerm_container_registry.default.name} &&\
        docker build -t ${local.dns_certbot_docker_image} dns &&\
        docker push ${local.dns_certbot_docker_image}
    EOF
  }
}
