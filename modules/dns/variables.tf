variable "core_json" {
  type = string
}

locals {
  core = jsondecode(var.core_json).core
}
