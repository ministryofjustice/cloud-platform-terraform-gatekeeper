variable "cluster_domain_name" {
  description = "The cluster domain used for externalDNS annotations and certmanager"
}

variable "enable_invalid_hostname_policy" {
  description = "Enable wheter to have the OPA policy of invalid hostname enabled"
  default     = false
  type        = bool
}

variable "define_constraints" {
  description = "if false, only the app is deployed, no constraints"
  default     = true
  type        = bool
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
