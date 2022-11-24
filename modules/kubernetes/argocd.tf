resource "null_resource" "deploy_argocd" {
  depends_on = [
    null_resource.deploy_ingress_nginx,
    null_resource.argocd_plugin_docker_build_push,
    null_resource.set_kubernetes_context,
  ]
  triggers = {
    version        = "7"
    plugin_version = local.argocd_plugin_version
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd} &&\
      python3 apps/argocd/deploy.py \
          ${var.dns.root_domain} \
          ${azuread_group.default_kubernetes_admins.object_id} \
          ${data.azuredevops_git_repository.uumpa_iac.remote_url} \
          ${local.argocd_plugin_docker_image} \
          ${var.core_resources.key_vault.name}
    EOF
  }
}
