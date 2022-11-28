resource "azurerm_dns_zone" "default" {
  name = local.root_domain
  resource_group_name = local.core.default_resource_group.name
}

locals {
  nameservers_setup_instructions = <<EOF

You need to set the nameservers for your domain.

Login to your domain registrar for domain ${local.root_domain} and set the following nameservers:

${join("\n", azurerm_dns_zone.default.name_servers)}

EOF
}

resource "null_resource" "check_dns_name_servers" {
  triggers = {
    version = "1"
    dns_name_servers = join(",", azurerm_dns_zone.default.name_servers)
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/bin/check_name_servers.sh ${local.root_domain} \"${local.nameservers_setup_instructions}\" ${join(" ", azurerm_dns_zone.default.name_servers)}"
  }
}
