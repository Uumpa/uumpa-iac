locals {
    automation_admin_user_name_secret_name = "sonarqube-automation-admin-user-name"
    automation_admin_user_password_secret_name = "sonarqube-automation-admin-user-password"
    automation_admin_token_secret_name = "sonarqube-admin-automation-token"
    script_file = "bin/automation_admin_user.py"
    command = <<-EOF
        python3 ${local.script_file} \
            "${local.core.default_key_vault.name}" \
            "${local.automation_admin_user_name_secret_name}" \
            "${local.automation_admin_user_password_secret_name}" \
            "https://sonarqube.${local.dns.root_domain}" \
            "${local.automation_admin_token_secret_name}"
    EOF
}

resource "null_resource" "automation_user" {
    triggers = {
        md5 = filemd5("${path.module}/${local.script_file}")
        command = local.command
    }
    provisioner "local-exec" {
        command = <<-EOF
            cd ${path.module}
            ${local.command}
        EOF
    }
}
