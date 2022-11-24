locals {
  wildcard_pfx_secret_name = "${var.name_prefix}-wildcard-pfx"
}

resource "null_resource" "certbot" {
  depends_on = [null_resource.check_dns_name_servers]
  triggers   = {
    version = 1
  }
  provisioner "local-exec" {
    command = "cd ${path.cwd} && python3 dns/certbot.py ${var.core_resources.key_vault.name} ${local.wildcard_pfx_secret_name} ${local.root_domain} ${local.letsencrypt_email} ${var.core_resources.group.name}"
  }
}
