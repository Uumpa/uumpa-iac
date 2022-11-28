module "github_sync_variable_group" {
  source = "../common/azure_devops_keyvault_variable_group"
  key_vault_name = local.core.default_key_vault.name
  name = "github gamal sync"
  project_id = local.uumpa_devops.azuredevops_uumpa_project_id
  service_endpoint_id = local.uumpa_devops.service_endpoint_id
  variables = {
    "${local.github_sync_ssh_key_secret_name}-private": {}
  }
}
