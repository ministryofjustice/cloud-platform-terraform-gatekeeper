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
    snippet_allowlist                  = bool
    modsec_snippet_nginx_class         = bool
    modsec_nginx_class                 = bool
    ingress_clash                      = bool
    hostname_length                    = bool
    external_dns_identifier            = bool
    external_dns_weight                = bool
    valid_hostname                     = bool
    warn_service_account_secret_delete = bool
  })
}

