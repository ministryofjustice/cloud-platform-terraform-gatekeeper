resource "kubernetes_manifest" "unique-ingress" {
  provider = kubernetes-alpha
  depends_on = [helm_release.gatekeeper]

  manifest = {
    "apiVersion" = "templates.gatekeeper.sh/v1beta1"
    "kind"       = "ConstraintTemplate"
    "metadata" = {
      "annotations" = {
        "description" = "Requires all Ingress hosts to be unique."
      }
      "name" = "k8suniqueingresshost"
    }
    "spec" = {
      "crd" = {
        "spec" = {
          "names" = {
            "kind" = "K8sUniqueIngressHost"
          }
        }
      }
      "targets" = [
        {
          "rego"   = <<-EOT
          package k8suniqueingresshost

          identical(obj, review) {
            obj.metadata.namespace == review.object.metadata.namespace
            obj.metadata.name == review.object.metadata.name
          }

          violation[{"msg": msg}] {
            input.review.kind.kind == "Ingress"
            re_match("^(extensions|networking.k8s.io)$", input.review.kind.group)
            host := input.review.object.spec.rules[_].host
            other := data.inventory.namespace[ns][otherapiversion]["Ingress"][name]
            re_match("^(extensions|networking.k8s.io)/.+$", otherapiversion)
            other.spec.rules[_].host == host
            not identical(other, input.review)
            msg := sprintf("ingress host conflicts with an existing ingress <%v>", [host])
          }

          EOT
          "target" = "admission.k8s.gatekeeper.sh"
        },
      ]
    }
  }
}
