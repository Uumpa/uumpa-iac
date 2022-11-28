variable "kubernetes_json" {
  type = string
}

locals {
  kubernetes = jsondecode(var.kubernetes_json).kubernetes
  dns = local.kubernetes.dns
  core = local.dns.core
}
