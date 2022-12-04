output "user_object_id" {
  value = azuread_user.user.object_id
}

output "group_descriptor" {
  value = azuredevops_group.group.descriptor
}

output "project_id" {
  value = data.azuredevops_project.proj.project_id
}
