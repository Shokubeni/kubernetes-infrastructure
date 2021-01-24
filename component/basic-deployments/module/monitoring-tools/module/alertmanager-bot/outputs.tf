output "alertmanager_bot" {
  value = {
    namespace = helm_release.alertmanager_bot.namespace
    version   = helm_release.alertmanager_bot.version
    name      = helm_release.alertmanager_bot.name
  }

  depends_on = [
    helm_release.alertmanager_bot
  ]
}