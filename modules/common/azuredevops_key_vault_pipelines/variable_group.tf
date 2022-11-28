resource "azuredevops_variable_group" "github_azdo_sync_pipeline" {
  depends_on = [
    azurerm_key_vault_access_policy.pol
  ]
  project_id = var.project_id
  name = var.variable_group_name
  key_vault {
    name = var.key_vault_name
    service_endpoint_id = local.service_endpoint.id
  }
  variable {
    for_each = var.variable_names
    name = each
  }
}
