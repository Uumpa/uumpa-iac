locals {
  wildcard_pfx_secret_name = "${local.core.environment_name}-wildcard-pfx"
}

resource "null_resource" "certbot" {
  depends_on = [null_resource.check_dns_name_servers]
  triggers   = {
    version = 1
  }
  provisioner "local-exec" {
    command = <<EOF
      cd ${path.cwd} &&\
      python3 dns/certbot.py \
        ${local.core.default_key_vault.name} \
        ${local.wildcard_pfx_secret_name} \
        ${local.root_domain} \
        ${local.letsencrypt_email} \
        ${local.core.default_resource_group.name}
    EOF
  }
}
