module "ssh_key" {
  source = "../ssh_key_secret"
  key_comment = var.key_comment
  key_vault_name = var.key_vault_name
  key_vault_id = var.key_vault_id
  secret_name = var.secret_name
}
