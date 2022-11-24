data "azuread_domains" "aad_domains" {}

data "azuredevops_project" "uumpa" {
  name = "uumpa"
}

data "azuredevops_git_repository" "uumpa_iac" {
  project_id = data.azuredevops_project.uumpa.id
  name       = "uumpa-iac"
}

resource "random_password" "argocd_azure_devops" {
  length  = 32
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azuread_user" "argocd_azure_devops" {
  display_name = "${var.name_prefix} ArgoCD Azure Devops Integration"
  user_principal_name = "${var.name_prefix}-argocd-azure-devops@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  password = random_password.argocd_azure_devops.result
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

resource "azuredevops_user_entitlement" "argocd" {
  principal_name = azuread_user.argocd_azure_devops.user_principal_name
}

resource "azuredevops_group" "argocd" {
  display_name = "${var.name_prefix} ArgoCD Automation"
  members = [
    azuredevops_user_entitlement.argocd.descriptor
  ]
}

resource "azuredevops_project_permissions" "argocd_uumpa" {
  project_id  = data.azuredevops_project.uumpa.id
  principal   = azuredevops_group.argocd.descriptor
  permissions = {
    GENERIC_READ = "Allow"
  }
}

resource "azuredevops_git_permissions" "argocd_uumpa_iac" {
  project_id = data.azuredevops_project.uumpa.id
  repository_id = data.azuredevops_git_repository.uumpa_iac.id
  principal = azuredevops_group.argocd.descriptor
  permissions = {
    "GenericRead" = "Allow"
  }
}

locals {
  argocd_azdo_user_password_secret_name = "${var.name_prefix}-argocd-azdo-user-password"
}

resource "null_resource" "argocd_azdo_user_password" {
  depends_on = [
    azuredevops_git_permissions.argocd_uumpa_iac
  ]
  triggers = {
    version = "1"
  }
  provisioner "local-exec" {
    command = <<EOF
      python3 ${path.cwd}/bin/set_user_password.py \
        ${var.core_resources.key_vault.name} \
        ${local.argocd_azdo_user_password_secret_name} \
        ${azuread_user.argocd_azure_devops.user_principal_name}
    EOF
  }
}
