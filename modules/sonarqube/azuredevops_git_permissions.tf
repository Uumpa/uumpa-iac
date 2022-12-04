data "azuredevops_git_repository" "gamal" {
  project_id = module.azuredevops_proj_repo_user.project_id
  name = "gamal"
}

resource "azuredevops_git_permissions" "gamal" {
  project_id = module.azuredevops_proj_repo_user.project_id
  repository_id = data.azuredevops_git_repository.gamal.id
  principal = module.azuredevops_proj_repo_user.group_descriptor
  permissions = {
    GenericRead = "Allow"
  }
}
