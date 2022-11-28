resource "random_password" "pass" {
  length  = 32
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azuread_user" "user" {
  display_name = var.user_display_name
  user_principal_name = var.user_principal_name
  password = random_password.pass.result
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

resource "azuredevops_user_entitlement" "userent" {
  principal_name = azuread_user.user.user_principal_name
}

resource "azuredevops_group" "group" {
  display_name = var.group_display_name
  members = [
    azuredevops_user_entitlement.userent.descriptor
  ]
}

resource "null_resource" "azdo_user_password" {
  depends_on = [
    azuredevops_git_permissions.gitperms
  ]
  triggers = {
    version = "1"
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.module} &&\
      python3 bin/set_user_password.py \
        ${var.key_vault_name} \
        ${var.user_password_secret_name} \
        ${azuread_user.user.user_principal_name}
    EOF
  }
}
