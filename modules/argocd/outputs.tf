output "argocd" {
  value = {
    service_principal_application_id = module.sp.service_principal_application_id
    service_principal_object_id = module.sp.service_principal_object_id
    service_principal_password_secret_name = local.service_principal_password_secret_name
  }
}
