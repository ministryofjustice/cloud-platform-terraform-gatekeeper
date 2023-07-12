# remember any kind used by a constraint template must also be added to the sync config at the end of this file
resource "kubectl_manifest" "constraint_templates" {
  for_each = fileset("${path.module}/resources/constraint_templates/", "*")

  yaml_body = file("${path.module}/resources/constraint_templates/${each.value}")
}

resource "kubectl_manifest" "constraints" {
  depends_on = [kubectl_manifest.constraint_templates, helm_release.gatekeeper]
  for_each   = local.constraint_map

  yaml_body = yamlencode("${each.value}")
}

/* add resources to sync here */
resource "kubectl_manifest" "config_sync" {
  depends_on = [helm_release.gatekeeper]

  yaml_body = <<YAML
apiVersion: config.gatekeeper.sh/v1alpha1
kind: Config
metadata:
  name: config
  namespace: "gatekeeper-system"
spec:
  sync:
    syncOnly:
      - group: "networking.k8s.io"
        version: "v1"
        kind: "Ingress"
      - group: ""
        version: "v1"
        kind: "Namespace"
      - group: ""
        version: "v1"
        kind: "Pod"
      - group: ""
        version: "v1"
        kind: "Service"
YAML
}

