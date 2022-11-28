variable "secret_name" {}
variable "key_vault_name" {}
variable "expected_value" {}
variable "instructions" {}

locals {
  command = <<-EOF
    bash bin/check.sh \
      ${var.secret_name} \
      ${var.key_vault_name} \
      "${var.expected_value}" \
      "${var.instructions}"
  EOF
}

resource "null_resource" "azure" {
  triggers = {
    command = local.command
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.module}
      ${local.command}
    EOF
  }
}
