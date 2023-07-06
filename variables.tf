variable "cluster_domain_name" {
  description = "The cluster domain used for externalDNS annotations and certmanager"
}

variable "constraint_violations_max_to_display" {
  description = "the max number of violations to display per constraint"
  default     = 20
  type        = number
}

variable "is_production" {
  description = "is this a production environment"
  type        = string
}

variable "environment_name" {
  description = "production || development"
  type        = string
}

variable "out_of_hours_alert" {
  description = "true || false"
  type        = string
}

variable "controller_mem_limit" {
  description = "memory limit for the gatekeeper controller manager"
  type        = string
}

variable "controller_mem_req" {
  description = "memory request for gatekeeper controller manager"
  type        = string
}

variable "audit_mem_limit" {
  description = "memory limit for gatekeeper audit"
  type        = string
}

variable "audit_mem_req" {
  description = "memory req for gatekeeper audit"
  type        = string
}

variable "cluster_color" {
  description = "Cluster color. This variable is effective only when external_dns_weight is not in dryrun"
  default     = "black"
  type        = string
}

variable "dryrun_map" {
  description = "run constraints in dryrun mode "
  type = object({
    service_type               = bool
    snippet_allowlist          = bool
    modsec_snippet_nginx_class = bool
    modsec_nginx_class         = bool
    ingress_clash              = bool
    hostname_length            = bool
    external_dns_identifier    = bool
    external_dns_weight = bool
  })
}

