resource "azuredevops_user_entitlement" "ent" {
  principal_name = local.azdo_user_name
}

resource "azuredevops_group" "grp" {
  display_name = "Uumpa ArgoCD Automation"
  members = [
    azuredevops_user_entitlement.ent.descriptor
  ]
}

resource "azuredevops_project_permissions" "proj" {
  project_id = data.azuredevops_project.uumpa.project_id
  principal = azuredevops_group.grp.descriptor
  permissions = {
    GENERIC_READ = "Allow"
  }
}

resource "azuredevops_git_permissions" "git" {
  project_id = data.azuredevops_project.uumpa.project_id
  repository_id = data.azuredevops_git_repository.uumpa_iac.id
  principal = azuredevops_group.grp.descriptor
  permissions = {
    "GenericRead" = "Allow"
  }
}
