resource "kubernetes_role" "plugin_deployer" {
  metadata {
    name = "plugin-deployer"
    namespace = "argocd"
  }
  rule {
    api_groups = ["apps", "extensions"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch", "update", "patch"]
  }
}

resource "kubernetes_role_binding" "plugin_deployer" {
  depends_on = [kubernetes_role.plugin_deployer]
  metadata {
    name = "plugin-deployer"
    namespace = "argocd"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "plugin-deployer"
  }
  subject {
    kind = "User"
    name = local.uumpa_devops.service_endpoint_spn_object_id
  }
}
