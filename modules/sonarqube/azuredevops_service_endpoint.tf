resource "null_resource" "azdo_service_endpoint_token" {
  provisioner "local-exec" {
    command = <<-EOF
      python3 ${path.module}/bin/create_user_token.py \
        "${local.core.default_key_vault.name}" \
        "${local.automation_admin_token_secret_name}" \
        "azdo_service_endpoint" \
        "https://sonarqube.${local.dns.root_domain}" \
        "sonarqube-token-azdo-service-endpoint" \
        "azdo_service_endpoint"
    EOF
  }
}

resource "null_resource" "azdo_service_endpoint" {
  provisioner "local-exec" {
    command = <<-EOF
      python3 ${path.module}/bin/azdo_service_endpoint.py \
        "SonarQube" "https://sonarqube.${local.dns.root_domain}" \
        "sonarqube-token-azdo-service-endpoint" \
        "${local.core.default_key_vault.name}" \
        "${module.azuredevops_proj_repo_user.project_id}"
    EOF
  }
}

module "project_keys" {
  source = "../common/external_data_command"
  script = "python3 ${path.cwd}/modules/sonarqube/bin/get_project_keys.py ${local.core.default_key_vault.name} sonarqube-admin-automation-token https://sonarqube.${local.dns.root_domain}"
}

resource "azuredevops_variable_group" "sonarqube" {
  name = "sonarqube"
  project_id = module.azuredevops_proj_repo_user.project_id
  dynamic "variable" {
    for_each = module.project_keys.output
    content {
      name = "sq-project-key-${variable.key}"
      value = variable.value
    }
  }
}
