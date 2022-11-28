resource "azurerm_key_vault_access_policy" "certbot" {
  key_vault_id = var.key_vault_id
  tenant_id = var.tenant_id
  object_id = module.sp.service_principal_object_id
  certificate_permissions = var.key_vault_certificate_permissions
}
