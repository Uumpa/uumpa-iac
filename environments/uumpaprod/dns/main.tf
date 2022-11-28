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

module "dns" {
  source = "../../../modules/dns"
  core_json = jsonencode(data.terraform_remote_state.core.outputs)
}

data "terraform_remote_state" "core" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.default_resourcegroup_name
    storage_account_name = var.secure_blobs_storage_account_name
    container_name       = var.secure_blobs_container_name
    key                  = "${var.backend_key_prefix}.core"
  }
}

output "dns" {
  value = module.dns.dns
}
