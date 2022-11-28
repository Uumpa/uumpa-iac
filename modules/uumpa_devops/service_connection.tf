module "uumpa_service_endpoints" {
  source = "../common/external_data_command"
  script = "az devops service-endpoint list -p uumpa"
}

locals {
  service_connection_name = "uumpa service connection"
  service_endpoints = [
    for service_endpoint in module.uumpa_service_endpoints.output : service_endpoint if service_endpoint.name == local.service_connection_name
  ]
}

resource "null_resource" "check_service_connection" {
  count = length(local.service_endpoints) == 0 ? 1 : 0
  triggers = {
    version = "1"
  }
  provisioner "local-exec" {
    command = <<EOF
echo "

Log-in to your Azure DevOps account -> Project settings -> Service Connections.

Add an Azure Resource Manager connection using service principal (automatic) with the following settings:

* Subscription: \"${local.core.current_subscription.display_name}(${local.core.current_subscription.subscription_id})\"
* Resource Group: \"${local.core.default_resource_group.name}\"
* Service connection name: \"${local.service_connection_name}\"

"
exit 1
EOF
  }
}
