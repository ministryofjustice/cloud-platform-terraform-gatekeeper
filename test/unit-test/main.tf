provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "gatekeeper" {
  source = "../../"

  cluster_domain_name                  = "gatekeeper.cloud-platform.service.justice.gov.uk"
  enable_invalid_hostname_policy       = false
  define_constraints                   = true
  constraint_violations_max_to_display = 25
  is_production                        = "false"
  environment_name                     = "development"
  out_of_hours_alert                   = "false"
  controller_mem_limit                 = "1Gi"
  controller_mem_req                   = "512Mi"
  audit_mem_limit                      = "1Gi"
  audit_mem_req                        = "512Mi"
}
