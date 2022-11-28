resource "azuread_group" "default_admins" {
  display_name = "${var.environment_name} default admins"
  security_enabled = true
}

resource "azuread_group_member" "first_admin" {
  group_object_id = azuread_group.default_admins.object_id
  member_object_id = data.azuread_user.current.object_id
  lifecycle {
    ignore_changes = [
      member_object_id
    ]
  }
}
