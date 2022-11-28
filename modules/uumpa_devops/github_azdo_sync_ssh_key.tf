locals {
  github_azdo_sync_ssh_key_secret_name = "github-azure-devops-sync-ssh-key"
}

module "github_azdo_sync_ssh_key" {
  source = "../common/ssh_key_secret_github_azdo"
  key_comment = "github-azure-devops-sync"
  key_vault_name = local.core.default_key_vault.name
  key_vault_id = local.core.default_key_vault.id
  secret_name = "github-azure-devops-sync-ssh-key"
  azdo_user_password_secret_name = local.azdo_user_password_secret_name
  azdo_username = local.azdo_user_name
  repo_name = "uumpa-iac"
}
