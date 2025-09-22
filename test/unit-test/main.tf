provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "gatekeeper" {
  source = "../../"

  cluster_domain_name = "gatekeeper.cloud-platform.service.justice.gov.uk"
  dryrun_map = {
    service_type                       = true,
    snippet_allowlist                  = true,
    modsec_snippet_nginx_class         = true,
    modsec_nginx_class                 = true,
    ingress_clash                      = true,
    hostname_length                    = true,
    external_dns_identifier            = true,
    external_dns_weight                = true,
    valid_hostname                     = true,
    warn_service_account_secret_delete = true,
    user_ns_requires_psa_label         = true,
    deprecated_apis_1_26               = true,
    deprecated_apis_1_27               = true,
    deprecated_apis_1_29               = true,
    lock_priv_capabilities             = true,
    warn_kubectl_create_sa             = true,
    allow_duplicate_hostname_yaml      = true,
    block_ingresses                    = false,
    ingress_valid_classname            = true,
    ingress_internal_class_domain      = true,
  }
  cluster_color                        = "green"
  constraint_violations_max_to_display = 25
  is_production                        = "false"
  environment_name                     = "development"
  out_of_hours_alert                   = "false"
  controller_mem_limit                 = "1Gi"
  controller_mem_req                   = "512Mi"
  audit_mem_limit                      = "1Gi"
  audit_mem_req                        = "512Mi"
}
