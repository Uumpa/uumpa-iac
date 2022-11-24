variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "core_resources" {
  type = object({
    group = object({
      id = string
      name = string
    })
    key_vault = object({
      id = string
      name = string
    })
    subscription = object({
      subscription_id = string
      tenant_id = string
    })
  })
}
