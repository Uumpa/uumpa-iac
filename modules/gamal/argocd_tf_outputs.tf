module "kubernetes_context" {
  source = "../common/set_kubernetes_context"
  cluster_name = local.kubernetes.cluster_name
  resource_group_name = local.core.default_resource_group.name
  subscription_id = local.core.current_subscription.subscription_id
}

module "tf_outputs" {
  depends_on = [module.kubernetes_context]
  source = "../common/argocd_tf_output_update"
  application = "gamal"
  data = {
    gamal_wildcard_pfx_secret_name = local.wildcard_pfx_secret_name
  }
  argocd_domain = "argocd.${local.dns.root_domain}"
  field_manager = "terraform_module_gamal"
  keyvault_name = local.core.default_key_vault.name
  token_secret_name = "argocd-syncer-user-token"
}
