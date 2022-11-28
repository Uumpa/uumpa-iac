variable "project_id" {}
variable "name" {}
variable "key_vault_name" {}
variable "service_endpoint_id" {}
variable "variables" {
  type = map(object({
    value = optional(string)
    secret_value = optional(string)
    is_secret = optional(bool)
  }))
}
