variable "service_connection_name" {
  type = string
}

variable "subscription" {
  type = object({
    display_name = string
    subscription_id = string
    tenant_id = string
  })
}

variable "resource_group_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "secret_permissions" {
  type = list(string)
  default = [
    "Get",
    "List"
  ]
}

variable "variable_group_name" {
  type = string
}

variable "variable_names" {
  type = list(string)
}
