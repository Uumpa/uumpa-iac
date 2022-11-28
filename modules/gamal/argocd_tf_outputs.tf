module "kubernetes_context" {
  source = "../common/set_kubernetes_context"
  cluster_name = local.kubernetes.cluster_name
  resource_group_name = local.core.default_resource_group.name
  subscription_id = local.core.current_subscription.subscription_id
}

resource "kubernetes_config_map_v1_data" "tf_outputs" {
  field_manager = "terraform_module_gamal"
  metadata {
    name      = "tf-outputs"
    namespace = "argocd"
  }
  data = {
    gamal_wildcard_pfx_secret_name = local.wildcard_pfx_secret_name
  }
}
