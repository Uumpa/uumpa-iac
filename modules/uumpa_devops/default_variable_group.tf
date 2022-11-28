resource "azuredevops_variable_group" "default" {
  name = "uumpa devops"
  project_id = data.azuredevops_project.uumpa.project_id
  variable {
    name = "container_registry_name"
    value = local.kubernetes.container_registry_name
  }
  variable {
    name = "container_registry_login_server"
    value = local.kubernetes.container_registry_login_server
  }
  variable {
    name = "appconfig_name"
    value = azurerm_app_configuration.default.name
  }
}
