data "azuredevops_project" "uumpa" {
  name = "uumpa"
}

data "azuredevops_git_repository" "uumpa_iac" {
  project_id = data.azuredevops_project.uumpa.id
  name       = "uumpa-iac"
}
