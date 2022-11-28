variable "wildcard_pfx_secret_name" {}
variable "key_vault_name" {}
variable "root_domain_name" {}
variable "letsencrypt_email" {}
variable "resource_group_name" {}

locals {
  command = <<-EOF
    python3 dns/certbot.py \
        ${var.key_vault_name} \
        ${var.wildcard_pfx_secret_name} \
        ${var.root_domain_name} \
        ${var.letsencrypt_email} \
        ${var.resource_group_name}
  EOF
}

resource "null_resource" "certbot" {
  triggers   = {
    dns_md5 = join(",", [for filename in fileset(path.cwd, "dns/**") : filemd5("${path.cwd}/${filename}")])
    command = local.command
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd}
      ${local.command}
    EOF
  }
}
