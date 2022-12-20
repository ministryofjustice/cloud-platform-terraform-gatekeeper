# remember any kind used by a constraint template must also be added to the sync config at the end of this file


data "kubectl_filename_list" "constraint-templates" {
    pattern = "${path.module}/resources/constraints/*_template.yaml"
}

data "kubectl_filename_list" "constraints" {
  pattern = "${path.module}/resources/constraints/*_constraint.yaml"
}

resource "kubectl_manifest" "constraint-templates" {
  depends_on    = [helm_release.gatekeeper]
  count         = length(data.kubectl_filename_list.constraint-templates.matches)
  yaml_body     = file(element(data.kubectl_filename_list.constraint-templates.matches, count.index))
}

resource "kubectl_manifest" "constraints" {
  depends_on    = [helm_release.gatekeeper]
  count         = length(data.kubectl_filename_list.constraints.matches)
  yaml_body     = file(element(data.kubectl_filename_list.constraints.matches, count.index))
}

# Resources to be synced here
resource "kubectl_manifest" "config-sync" {
  depends_on    = [helm_release.gatekeeper]

  yaml_body     = file("${path.module}/resources/config_sync.yaml")
}


/* This dosn't work, to be fixed in next PR
resource "kubectl_manifest" "pod-tolerations-template" {
  count = var.define_constraints == true ? 1 : 0
  depends_on = [helm_release.gatekeeper]

  yaml_body = <<YAML
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8spodtolerations
  annotations:
    description: do not schedule any workloads on master nodes.
spec:
  crd:
    spec:
      names:
        kind: k8spodtolerations
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8spodtolerations
        violation[{"msg": msg}] {
          not input.review.kind.kind == "Pod"
          msg := "WIP"
        }
YAML
}
*/

/* This dosn't work, to be fixed in next PR 
resource "kubectl_manifest" "pod-tolerations-constraint" {
  count = var.define_constraints == true ? 1 : 0
  depends_on = [kubectl_manifest.pod-tolerations-template]

  yaml_body = <<YAML
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: k8spodtolerations
metadata:
  name: k8spodtolerations
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
YAML
}
*/
