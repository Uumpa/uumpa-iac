resource "azuread_group" "admins" {
  display_name     = var.admins_group_display_name
  security_enabled = true
}

resource "azuread_group_member" "first_admin" {
  group_object_id = azuread_group.admins.object_id
  member_object_id = var.first_admin_member_object_id
}
