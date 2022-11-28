resource "azuredevops_variable_group" "vg" {
  project_id = var.project_id
  name = var.name
  key_vault {
    name = var.key_vault_name
    service_endpoint_id = var.service_endpoint_id
  }
  dynamic "variable" {
    for_each = var.variables
    content {
      name = variable.key
      value = variable.value.value
      secret_value = variable.value.secret_value
      is_secret = variable.value.is_secret
    }
  }
}
