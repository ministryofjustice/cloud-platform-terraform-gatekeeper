resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = "gatekeeper-system"

    labels = {
      "name"                                           = "gatekeeper-system"
      "cloud-platform.justice.gov.uk/is-production"    = var.is_production
      "cloud-platform.justice.gov.uk/environment-name" = var.environment_name
      "admission.gatekeeper.sh/ignore"                 = "no-self-managing"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Gatekeeper"
      "cloud-platform.justice.gov.uk/business-unit" = "Platforms"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform.justice.gov.uk/slack-channel" = "cloud-platform"
      "cloud-platform-out-of-hours-alert"           = var.out_of_hours_alert
    }
  }
}

resource "helm_release" "gatekeeper" {
  name       = "gatekeeper"
  namespace  = kubernetes_namespace.gatekeeper.id
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  version    = "3.12.0"

  # https://github.com/open-policy-agent/gatekeeper/blob/master/charts/gatekeeper/values.yaml
  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    audit_from_cache                     = "true"
    post_install_label_namespace         = "false"
    constraint_violations_max_to_display = var.constraint_violations_max_to_display
    controller_mem_limit                 = var.controller_mem_limit
    controller_mem_req                   = var.controller_mem_req
    audit_mem_limit                      = var.audit_mem_limit
    audit_mem_req                        = var.audit_mem_req
  })]

  lifecycle {
    ignore_changes = [keyring]
  }
}

