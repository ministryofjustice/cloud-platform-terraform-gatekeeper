resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = "gatekeeper"

    labels = {
      "name"                                           = "gatekeeper"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "admission.gatekeeper.sh/ignore"                 = "no-self-managing"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Gatekeeper"
      "cloud-platform.justice.gov.uk/business-unit" = "Platforms"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform.justice.gov.uk/slack-channel" = "cloud-platform"
      "cloud-platform-out-of-hours-alert"           = "true"
    }
  }
}

resource "helm_release" "gatekeeper" {
  name       = "gatekeeper"
  namespace  = kubernetes_namespace.gatekeeper.id
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  version    = "3.4.0"

  set {
    name  = "enableDeleteOperations"
    value = "true"
  }

  set {
    name  = "postInstall.labelNamespace.enabled"
    value = "true"
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}
