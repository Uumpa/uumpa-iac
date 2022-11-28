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

module "core" {
  source = "../../../modules/core"
  default_location = "West Europe"
  environment_name = var.environment_name
}

output "core" {
  value = module.core.core
}

output "environment_name" {
  value = module.core.core.environment_name
}

output "default_location" {
  value = module.core.core.default_location
}
