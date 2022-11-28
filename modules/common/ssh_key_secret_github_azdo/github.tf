module "github" {
  source         = "../check_secret"
  key_vault_name = var.key_vault_name
  secret_name    = "${var.secret_name}-added-to-github"
  expected_value = "true"
  instructions   = <<EOF

Login to GitHub and add the following public key to ${var.repo_name} as a deploy key with write access:

${module.ssh_key.public_key}

When done, run the following to continue:

az keyvault secret set --vault-name ${var.key_vault_name} --name ${var.secret_name}-added-to-github --value true

EOF
}
