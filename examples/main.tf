module "gatekeeper" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-gatekeeper?ref=1.1.2"

  cluster_domain_name = data.terraform_remote_state.cluster.outputs.cluster_domain_name
  # boolean expression for applying opa valid hostname for test clusters only.
  dryrun_map                           = { service_type = true, snippet_allowlist = true, modsec_snippet_nginx_class = true, modsec_nginx_class = true, ingress_clash = true, hostname_length = true, external_dns_identifier = true, external_dns_weight = true, valid_hostname = true, warn_service_account_secret_delete = true, user_ns_requires_psa_label = true }
  cluster_color                        = "green"
  constraint_violations_max_to_display = 25
  is_production                        = terraform.workspace == local.production_workspace ? "true" : "false"
  environment_name                     = terraform.workspace == local.production_workspace ? "production" : "development"
  out_of_hours_alert                   = terraform.workspace == local.production_workspace ? "true" : "false"
  controller_mem_limit                 = terraform.workspace == local.live_workspace ? "4Gi" : "1Gi"
  controller_mem_req                   = terraform.workspace == local.live_workspace ? "1Gi" : "512Mi"
  audit_mem_limit                      = terraform.workspace == local.live_workspace ? "4Gi" : "1Gi"
  audit_mem_req                        = terraform.workspace == local.live_workspace ? "1Gi" : "512Mi"

}
