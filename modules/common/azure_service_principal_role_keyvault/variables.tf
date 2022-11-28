variable "name" {}
variable "scope" {}
variable "permissions_actions" {
  type = list(string)
}
variable "key_vault_id" {}
variable "key_vault_name" {}
variable "tenant_id" {}
variable "key_vault_certificate_permissions" {
  type = list(string)
}
variable "subscription_id" {}
variable "service_principal_password_secret_name" {}
