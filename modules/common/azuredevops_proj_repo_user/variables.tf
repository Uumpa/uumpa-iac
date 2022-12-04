variable "project" {
  type = string
}

variable "repository" {
  type = string
}

variable "user_display_name" {
  type = string
}

variable "user_principal_name" {
  type = string
  description = "name@aad_domain"
}

variable "group_display_name" {
  type = string
}

variable "git_permissions" {
  type = map(string)
  default = {
    GenericRead = "Allow"
  }
}

variable "project_permissions" {
  type = map(string)
  default = {
    GENERIC_READ = "Allow"
  }
}

variable "key_vault_name" {
  type = string
}

variable "user_password_secret_name" {
  type = string
}

variable "azuredevops_token_secret_name" {
  type = string
  default = ""
}
