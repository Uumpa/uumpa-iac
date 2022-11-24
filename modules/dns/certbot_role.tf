locals {
  certbot_service_principal_name = "${var.name_prefix}-certbot"
  certbot_role_name = "${var.name_prefix}-certbot"
  certbot_service_principal_password_secret_name = "${var.name_prefix}-certbot-service-principal-password"
}

resource "azurerm_role_definition" "certbot" {
  name  = local.certbot_role_name
  scope = "/subscriptions/${var.core_resources.subscription.subscription_id}"
  permissions {
    actions = [
      "Microsoft.Network/dnszones/read",
      "Microsoft.Network/dnszones/TXT/read",
      "Microsoft.Network/dnszones/TXT/write",
      "Microsoft.Network/dnszones/TXT/delete",
    ]
  }
}

resource "null_resource" "certbot_service_principal" {
    triggers   = {
        version = "3"
    }
    provisioner "local-exec" {
        command = <<EOF
          cd ${path.cwd} &&\
          python3 bin/update_service_principal.py \
              ${local.certbot_service_principal_name} \
              ${local.certbot_role_name} \
              ${var.core_resources.subscription.subscription_id} \
              ${var.core_resources.key_vault.name} \
              ${local.certbot_service_principal_password_secret_name} \
              --retry
        EOF
    }
}

data "azuread_service_principal" "certbot" {
    depends_on = [null_resource.certbot_service_principal]
    display_name = local.certbot_service_principal_name
}

resource "azurerm_key_vault_access_policy" "certbot" {
  key_vault_id = var.core_resources.key_vault.id
  tenant_id = var.core_resources.subscription.tenant_id
  object_id = data.azuread_service_principal.certbot.object_id
  certificate_permissions = [
    "Create", "Delete", "Get", "Import", "List", "Update"
  ]
}
