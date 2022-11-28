resource "azuredevops_git_permissions" "gitperms" {
  project_id = data.azuredevops_project.proj.id
  repository_id = data.azuredevops_git_repository.repo.id
  principal = azuredevops_group.group.descriptor
  permissions = var.git_permissions
}
