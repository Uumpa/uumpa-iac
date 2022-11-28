resource "azuredevops_project_permissions" "projperms" {
  project_id  = data.azuredevops_project.proj.id
  principal   = azuredevops_group.group.descriptor
  permissions = var.project_permissions
}
