variable "domain_name" {}
variable "resource_group_name" {}

resource "azurerm_dns_zone" "zone" {
  name = var.domain_name
  resource_group_name = var.resource_group_name
}

locals {
  nameservers_setup_instructions = <<EOF

You need to set the nameservers for your domain.

Login to your domain registrar for domain ${var.domain_name} and set the following nameservers:

${join("\n", azurerm_dns_zone.zone.name_servers)}

EOF
}

resource "null_resource" "check_dns_name_servers" {
  triggers = {
    version = "1"
    dns_name_servers = join(",", azurerm_dns_zone.zone.name_servers)
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/bin/check_name_servers.sh ${var.domain_name} \"${local.nameservers_setup_instructions}\" ${join(" ", azurerm_dns_zone.zone.name_servers)}"
  }
}
