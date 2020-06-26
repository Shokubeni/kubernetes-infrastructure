output "kube_state" {
  value = {
    namespace = helm_release.kube_state.namespace
    version   = helm_release.kube_state.version
    name      = helm_release.kube_state.name
  }

  depends_on = [
    helm_release.kube_state
  ]
}