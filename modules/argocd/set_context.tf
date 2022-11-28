module "set_context" {
  source = "../common/set_kubernetes_context"
  cluster_name = local.kubernetes.cluster_name
  resource_group_name = local.core.default_resource_group.name
  subscription_id = local.core.current_subscription.subscription_id
}
