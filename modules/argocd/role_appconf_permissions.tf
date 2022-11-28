resource "azurerm_role_assignment" "app_conf" {
  principal_id = module.sp.service_principal_object_id
  role_definition_name = "App Configuration Data Reader"
  scope = local.uumpa_devops.default_app_configuration_id
  skip_service_principal_aad_check = true
}
