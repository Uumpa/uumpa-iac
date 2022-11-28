locals {
  service_connection_manual_instructions = <<EOF
Log-in to your Azure DevOps account -> Project settings -> Service Connections.
Add an Azure Resource Manager connection using service principal (automatic) with the following settings:
* Subscription: "${var.subscription.display_name}(${var.subscription.subscription_id})"
* Resource Group: "${var.resource_group_name}"
* Service connection name: "${var.service_connection_name}"
EOF
}

data "external" "service_endpoints" {
  working_dir = path.cwd
  program = ["python3", "bin/terraform_external_data_cmd.py"]
  query = {
    script = "az devops service-endpoint list -p ${var.project_name}"
  }
}

locals {
  service_endpoints = jsondecode(data.external.service_endpoints.result.output)
  service_endpoint = [
    for service_endpoint in local.service_endpoints : service_endpoint if service_endpoint.name == var.service_connection_name
  ][0]
}
