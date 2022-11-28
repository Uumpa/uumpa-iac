variable "name" {}
variable "key" {}

module "get" {
  source = "../external_data_command"
  script = <<EOF
    echo "{\"value\":\"$(az appconfig kv show \
      --name=${var.name} \
      --key ${var.key} --query value -o tsv)\"}"
  EOF
}

output "value" {
  value = module.get.output.value
}
