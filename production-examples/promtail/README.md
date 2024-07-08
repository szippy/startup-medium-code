module "argocd_deployment" {
  source           = "../argocd-helm-deployment/"
  name             = "promtail"
  chart            = "promtail"
  repo_url         = "https://grafana.github.io/helm-charts"
  release_name     = "promtail"
  namespace        = "logging-loki"
  create_namespace = false
  target_revision  = "6.15.5"
  values = templatefile("${path.module}/promtail.values.yaml.tpl", {
    promtail_service_account   = var.promtail_service_account
    promtail_kafka_broker      = var.promtail_kafka_broker
    promtail_resources         = var.promtail_resources
    env                        = var.env
    promtail_redpanda_regex    = var.promtail_redpanda_regex
    promtail_redpanda_user     = var.promtail_redpanda_user
    promtail_redpanda_password = var.promtail_redpanda_password
    loki_basic_auth_username   = var.loki_basic_auth_username
    loki_basic_auth_password   = var.loki_basic_auth_password

  })

}

resource "kubernetes_priority_class" "promtail" {
  metadata {
    name = "promtail"
  }

  value = 100
}