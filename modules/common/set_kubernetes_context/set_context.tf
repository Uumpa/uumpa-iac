resource "null_resource" "set_context" {
  triggers = {
    timestamp = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
      python3 ${path.module}/bin/set_context.py \
        ${var.cluster_name} \
        ${var.subscription_id} \
        ${var.resource_group_name} \
        --skip-if-context-exists
    EOF
  }
}
