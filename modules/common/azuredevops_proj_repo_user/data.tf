data "azuredevops_project" "proj" {
  name = var.project
}

data "azuredevops_git_repository" "repo" {
  project_id = data.azuredevops_project.proj.id
  name       = "uumpa-iac"
}
