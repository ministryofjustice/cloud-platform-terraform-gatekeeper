# remember any kind used by a constraint template must also be added to the sync config at the end of this file

resource "kubectl_manifest" "unique-ingress-template" {
  count = var.define_constraints == true ? 1 : 0
  depends_on = [helm_release.gatekeeper]

  yaml_body = <<YAML
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8suniqueingresshost
  annotations:
    description: Requires all Ingress hosts to be unique, unless they share a namespace.
spec:
  crd:
    spec:
      names:
        kind: k8suniqueingresshost
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8suniqueingresshost
        identical(obj, review) {
          obj.metadata.namespace == review.object.metadata.namespace
          obj.metadata.name == review.object.metadata.name
        }
        same_namespace(obj, review) {
          obj.metadata.namespace == review.object.metadata.namespace
        }
        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          re_match("^(extensions|networking.k8s.io)$", input.review.kind.group)
          host := input.review.object.spec.rules[_].host
          other := data.inventory.namespace[ns][otherapiversion]["Ingress"][name]
          re_match("^(extensions|networking.k8s.io)/.+$", otherapiversion)
          other.spec.rules[_].host == host
          namespace := other.metadata.namespace
          not identical(other, input.review)
          not same_namespace(other, input.review)
          msg := sprintf("ingress host conflicts with an existing ingress <%v> in namespace <%v>", [host, namespace])
        }
YAML
}

resource "kubectl_manifest" "unique-ingress-constraint" {
  count = var.define_constraints == true ? 1 : 0
  depends_on = [kubectl_manifest.unique-ingress-template]

  yaml_body = <<YAML
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: k8suniqueingresshost
metadata:
  name: k8suniqueingresshost
spec:
  match:
    kinds:
      - apiGroups: ["extensions", "networking.k8s.io"]
        kinds: ["Ingress"]
YAML
}

resource "kubectl_manifest" "ingress-default-modsec-template" {
  count = var.define_constraints == true ? 1 : 0
  depends_on = [helm_release.gatekeeper]

  yaml_body = <<YAML
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sdenydefaultmodsec
  annotations:
    description: This policy denies ingresses using default ingress-controller if they try to enable modsecurity.
spec:
  crd:
    spec:
      names:
        kind: k8sdenydefaultmodsec
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sdenydefaultmodsec
        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          input.review.object.metadata.annotations["kubernetes.io/ingress.class"] == "nginx"
          input.review.object.metadata.annotations["nginx.ingress.kubernetes.io/enable-modsecurity"] == "true"
          msg := "mod-security is not allowed for default ingress"
        }
        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          not input.review.object.metadata.annotations["kubernetes.io/ingress.class"]
          input.review.object.metadata.annotations["nginx.ingress.kubernetes.io/enable-modsecurity"] == "true"
          msg := "mod-security is not allowed for default ingress"
        }
        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          input.review.object.metadata.annotations["kubernetes.io/ingress.class"] == "nginx"
          input.review.object.metadata.annotations["nginx.ingress.kubernetes.io/modsecurity-snippet"]
          msg := "modsecurity-snippet is not allowed for default ingress"
        }
        violation[{"msg": msg}] {
          input.review.kind.kind == "Ingress"
          not input.review.object.metadata.annotations["kubernetes.io/ingress.class"]
          input.review.object.metadata.annotations["nginx.ingress.kubernetes.io/modsecurity-snippet"]
          msg := "modsecurity-snippet is not allowed for default ingress"
        }
YAML
}

resource "kubectl_manifest" "ingress-default-modsec-constraint" {
  count = var.define_constraints == true ? 1 : 0
  depends_on = [kubectl_manifest.ingress-default-modsec-template]

  yaml_body = <<YAML
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: k8sdenydefaultmodsec
metadata:
  name: k8sdenydefaultmodsec
spec:
  match:
    kinds:
      - apiGroups: ["extensions", "networking.k8s.io"]
        kinds: ["Ingress"]
YAML
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

/* add resources to sync here */
resource "kubectl_manifest" "config-sync" {
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

