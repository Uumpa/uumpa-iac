module "azure" {
  source         = "../check_secret"
  key_vault_name = var.key_vault_name
  secret_name    = "${var.secret_name}-added-to-azure"
  expected_value = "true"
  instructions   = <<EOF

Login to Azure DevOps with the following user:

  Username: ${var.azdo_username}
  Password: 'az keyvault secret show --vault-name ${var.key_vault_name} --name ${var.azdo_user_password_secret_name} --query value -o tsv'

Add the following public key for this user:

${module.ssh_key.public_key}

When done, run the following to continue:

az keyvault secret set --vault-name ${var.key_vault_name} --name ${var.secret_name}-added-to-azure --value true

EOF
}
