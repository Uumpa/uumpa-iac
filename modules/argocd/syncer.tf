locals {
  syncer_user_token_secret_name = "argocd-syncer-user-token"
  command = <<-EOF
    python3 bin/get_user_token.py "argocd.${local.dns.root_domain}" \
      "syncer" "${local.core.default_key_vault.name}" \
      "${local.syncer_user_token_secret_name}"
  EOF
}

resource "null_resource" "argocd_syncer_user_token" {
  depends_on = [module.set_context, null_resource.deploy_argocd]
  triggers = {
    command = local.command
    md5 = filemd5("${path.module}/bin/get_user_token.py")
  }
  provisioner "local-exec" {
    command = <<-EOF
      cd ${path.module}
      ${local.command}
    EOF
  }
}

resource "azurerm_key_vault_secret" "argocd_domain" {
  name         = "argocd-domain"
  value        = "argocd.${local.dns.root_domain}"
  key_vault_id = local.core.default_key_vault.id
}

module "github_sync_variable_group" {
  depends_on = [null_resource.argocd_syncer_user_token, azurerm_key_vault_secret.argocd_domain]
  source = "../common/azure_devops_keyvault_variable_group"
  key_vault_name = local.core.default_key_vault.name
  name = "argocd sync"
  project_id = local.uumpa_devops.azuredevops_uumpa_project_id
  service_endpoint_id = local.uumpa_devops.service_endpoint_id
  variables = {
    (local.syncer_user_token_secret_name): {}
    "argocd-domain": {}
  }
}
