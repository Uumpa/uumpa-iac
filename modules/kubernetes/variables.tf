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
    admins = object({
      members = list(string)
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

variable "dns" {
  type = object({
    root_domain = string
    letsencrypt_email = string
    wildcard_pfx_secret_name = string
    certbot_service_principal_app_id = string
  })
}
