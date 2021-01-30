output "open_vpn" {
  value = {
    namespace = helm_release.open_vpn.namespace
    version   = helm_release.open_vpn.version
    name      = helm_release.open_vpn.name
  }

  depends_on = [
    helm_release.open_vpn
  ]
}