variable "cluster_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "dns_prefix" {}
variable "kubernetes_version" {}
variable "admins_group_display_name" {}
variable "first_admin_member_object_id" {}
variable "container_registry_name" {default = ""}
variable "subscription_id" {}
variable "secretsstore_application_display_name" {default = ""}
variable "secretsstore_federated_identity_credential_subject" {default = ""}
variable "secretsstore_federated_identity_credential_display_name" {default = ""}
variable "secretsstore_keyvault_id" {default = ""}
variable "secretsstore_keyvault_name" {default = ""}
variable "tenant_id" {default = ""}
variable "deploy_secretsstore_app" {default = true}
variable "dns_wildcard_pfx_secret_name" {default = ""}
variable "deploy_ingress_nginx" {default = true}
variable "wildcard_dns_zone_name" {default = true}
variable "secrets_store_federated_identity_service_accounts" {default = []}
variable "secrets_store_federated_identities_name_prefix" {default = ""}
