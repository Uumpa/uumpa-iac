provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = local.cluster_name
}
