resource "null_resource" "generate" {
  triggers = {
    version = "1"
  }
  provisioner "local-exec" {
    command = <<EOF
      python3 ${path.module}/bin/generate.py \
        "${var.key_comment}" \
        ${var.key_vault_name} \
        ${var.secret_name}
    EOF
  }
}

data "azurerm_key_vault_secret" "public_key" {
  depends_on = [null_resource.generate]
  key_vault_id = var.key_vault_id
  name = "${var.secret_name}-public"
}