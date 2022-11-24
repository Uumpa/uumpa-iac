output "kubernetes" {
  value = {
  }
}

output "argocd_integration_username" {
  value = azuread_user.argocd_azure_devops.user_principal_name
}

output "argocd_integration_password_secret_name" {
  value = local.argocd_azdo_user_password_secret_name
}
