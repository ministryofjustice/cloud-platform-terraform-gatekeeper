output "envoy_gateway_namespace_labels" {
  description = "Envoy namespace PSA labels, available after the namespace policy exceptions are applied."
  value = {
    "pod-security.kubernetes.io/enforce" = "privileged"
  }

  depends_on = [module.constraints]
}
