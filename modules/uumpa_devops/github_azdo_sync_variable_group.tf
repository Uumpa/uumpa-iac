module "github_azdo_sync_variable_group" {
  source = "../common/azure_devops_keyvault_variable_group"
  key_vault_name = local.core.default_key_vault.name
  name = "github azdo sync"
  project_id = data.azuredevops_project.uumpa.id
  service_endpoint_id = local.service_endpoints[0].id
  variables = {
    "${local.github_azdo_sync_ssh_key_secret_name}-private": {}
  }
}
