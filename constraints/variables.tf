variable "cluster_domain_name" {
  description = "The cluster domain used for externalDNS annotations and certmanager"
}

variable "integration_test_zone" {
  description = "Integration test zone, for test clusters to use it for valid ingress policy"
  default     = ""
}

variable "cluster_color" {
  description = "Cluster color. This variable is effective only when external_dns_weight is not in dryrun"
  default     = "black"
  type        = string
}

variable "dryrun_map" {
  description = "run constraints in dryrun mode"
  type = object({
    service_type                       = bool
    warn_service_account_secret_delete = bool
    user_ns_requires_psa_label         = bool
    lock_priv_capabilities             = bool
    warn_kubectl_create_sa             = bool
  })
}

