provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = local.kubernetes.cluster_name
}
