module "check_azdo_token" {
  count = var.azuredevops_token_secret_name == "" ? 0 : 1
  depends_on = [null_resource.azdo_user_password]
  source = "../check_secret"
  key_vault_name = var.key_vault_name
  secret_name = var.azuredevops_token_secret_name
  expected_value = ""
  instructions = <<EOF

Generate a token for Azure DevOps integration:

Get the username and password:

username: ${var.user_principal_name}
password: bin/get_secret.py ENVIRONMENT_NAME ${var.user_password_secret_name}

Go to https://dev.azure.com/${var.project}/_usersSettings/tokens and login as that user

Generate a full access token with 1 year expiration

Set the token in keyvault:

bin/set_secret.py ENVIRONMENT_NAME ${var.azuredevops_token_secret_name} TOKEN

EOF
}