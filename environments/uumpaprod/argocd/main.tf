terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

variable "environment_name" {}
variable "default_resourcegroup_name" {}
variable "secure_blobs_storage_account_name" {}
variable "secure_blobs_container_name" {}
variable "backend_key_prefix" {}

module "argocd" {
  source = "../../../modules/argocd"
  uumpa_devops_json = jsonencode(data.terraform_remote_state.uumpa_devops.outputs)
}

data "terraform_remote_state" "uumpa_devops" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.default_resourcegroup_name
    storage_account_name = var.secure_blobs_storage_account_name
    container_name       = var.secure_blobs_container_name
    key                  = "${var.backend_key_prefix}.uumpa_devops"
  }
}

output "argocd" {
  value = module.argocd.argocd
}
