variable "dns_json" {
  type = string
}

locals {
  dns = jsondecode(var.dns_json).dns
  core = local.dns.core
}
