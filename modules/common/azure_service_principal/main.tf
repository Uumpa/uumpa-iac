variable "name" {}
variable "key_vault_name" {}
variable "service_principal_password_secret_name" {}
variable "role" {default = ""}
variable "scopes" {default = []}

resource "null_resource" "sp" {
    triggers   = {
        md5 = filemd5("${path.module}/bin/update_service_principal.py")
        name = var.name
        key_vault_name = var.key_vault_name
        service_principal_password_secret_name = var.service_principal_password_secret_name
        role = var.role
        scopes = join(" ", var.scopes)
    }
    provisioner "local-exec" {
        command = <<EOF
          python3 ${path.module}/bin/update_service_principal.py \
              "${var.name}" \
              "${var.role}" \
              "${join(" ", var.scopes)}" \
              "${var.key_vault_name}" \
              "${var.service_principal_password_secret_name}" \
              --retry
        EOF
    }
}

data "azuread_service_principal" "sp" {
    depends_on = [null_resource.sp]
    display_name = var.name
}

output "service_principal_application_id" {
  value = data.azuread_service_principal.sp.application_id
}

output "service_principal_object_id" {
  value = data.azuread_service_principal.sp.object_id
}
