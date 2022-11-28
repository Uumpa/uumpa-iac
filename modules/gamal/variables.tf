variable "uumpa_devops_json" {
  type = string
}

locals {
  uumpa_devops = jsondecode(var.uumpa_devops_json).uumpa_devops
  kubernetes = local.uumpa_devops.kubernetes
  dns = local.kubernetes.dns
  core = local.dns.core
}
