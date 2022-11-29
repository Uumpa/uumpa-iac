variable "field_manager" {}
variable "data" {
  type = map(string)
}
variable "token_secret_name" {}
variable "keyvault_name" {}
variable "argocd_domain" {}
variable "application" {}

resource "kubernetes_config_map_v1_data" "tf_outputs" {
  field_manager = var.field_manager
  metadata {
    name      = "tf-outputs"
    namespace = "argocd"
  }
  data = var.data
}

locals {
  command = <<-EOF
    python3 bin/sync.py "${var.token_secret_name}" "${var.keyvault_name}" "${var.argocd_domain}" "${var.application}"
  EOF
}

resource "null_resource" "syncer" {
  triggers = {
    data = jsonencode(var.data)
  }
  provisioner "local-exec" {
    command = <<-EOF
      cd ${path.module}
      ${local.command}
    EOF
  }
}
