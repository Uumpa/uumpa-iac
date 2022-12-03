output "uumpa_devops" {
  value = {
    kubernetes = local.kubernetes
    default_app_configuration_id = azurerm_app_configuration.default.id
    default_app_configuration_name = azurerm_app_configuration.default.name
    default_app_configuration_endpoint = azurerm_app_configuration.default.endpoint
    azuredevops_uumpa_project_id = data.azuredevops_project.uumpa.id
    azuredevops_git_repository_uumpa_iac_id: data.azuredevops_git_repository.uumpa_iac.id
    azuredevops_git_repository_uumpa_iac_remote_url: data.azuredevops_git_repository.uumpa_iac.remote_url
    azdo_user_object_id = module.azuredevops_proj_repo_user.user_object_id
    azdo_user_name = local.azdo_user_name
    azdo_user_password_secret_name = local.azdo_user_password_secret_name
    service_endpoint_id = local.service_endpoints[0].id
    service_endpoint_spn_object_id = local.service_endpoints[0].data.spnObjectId
  }
}
