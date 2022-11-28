locals {
  github_sync_ssh_key_secret_name = "gamal-repo-ssh-key"
}

module "github_sync_ssh_key" {
  source = "../common/ssh_key_secret_github"
  key_comment = "gamal-github-sync"
  key_vault_id = local.core.default_key_vault.id
  key_vault_name = local.core.default_key_vault.name
  repo_name = "gamal"
  secret_name = local.github_sync_ssh_key_secret_name
}
