locals {
  service_type_yaml                       = yamldecode(file("${path.module}/../resources/constraints/service_type.yaml"))
  snippet_allowlist_yaml                  = yamldecode(file("${path.module}/../resources/constraints/snippet_allowlist.yaml"))
  modsec_snippet_nginx_class_yaml         = yamldecode(file("${path.module}/../resources/constraints/modsec_snippet_nginx_class.yaml"))
  modsec_nginx_class_yaml                 = yamldecode(file("${path.module}/../resources/constraints/modsec_nginx_class.yaml"))
  ingress_clash_yaml                      = yamldecode(file("${path.module}/../resources/constraints/ingress_clash.yaml"))
  hostname_length_yaml                    = yamldecode(file("${path.module}/../resources/constraints/ingress_hostname_length.yaml"))
  external_dns_weight_yaml                = yamldecode(file("${path.module}/../resources/constraints/ingress_external_dns_weight.yaml"))
  external_dns_identifier_yaml            = yamldecode(file("${path.module}/../resources/constraints/ingress_external_dns_identifier.yaml"))
  valid_hostname_yaml                     = yamldecode(file("${path.module}/../resources/constraints/ingress_valid_hostname.yaml"))
  warn_service_account_secret_delete_yaml = yamldecode(file("${path.module}/../resources/constraints/warn_service_account_secret_delete.yaml"))
  user_ns_requires_psa_label_yaml         = yamldecode(file("${path.module}/../resources/constraints/user_ns_requires_psa_label.yaml"))

  # For each constraint, a value needs to be in the constraint map. This bloc allows us to set values on constraints which enables us to toggle the configuration of the constraints. -- we merge in the spec separately to avoid overwriting entire spec key
  constraint_map = {
    service_type                       = merge(local.service_type_yaml, { "spec" : merge(local.service_type_yaml["spec"], { "enforcementAction" : var.dryrun_map.service_type ? "dryrun" : "deny" }) })
    snippet_allowlist                  = merge(local.snippet_allowlist_yaml, { "spec" : merge(local.snippet_allowlist_yaml["spec"], { "enforcementAction" : var.dryrun_map.snippet_allowlist ? "dryrun" : "deny" }) })
    modsec_snippet_nginx_class         = merge(local.modsec_snippet_nginx_class_yaml, { "spec" : merge(local.modsec_snippet_nginx_class_yaml["spec"], { "enforcementAction" : var.dryrun_map.modsec_snippet_nginx_class ? "dryrun" : "deny" }) })
    modsec_nginx_class                 = merge(local.modsec_nginx_class_yaml, { "spec" : merge(local.modsec_nginx_class_yaml["spec"], { "enforcementAction" : var.dryrun_map.modsec_nginx_class ? "dryrun" : "deny" }) })
    ingress_clash                      = merge(local.ingress_clash_yaml, { "spec" : merge(local.ingress_clash_yaml["spec"], { "enforcementAction" : var.dryrun_map.ingress_clash ? "dryrun" : "deny" }) })
    hostname_length                    = merge(local.hostname_length_yaml, { "spec" : merge(local.hostname_length_yaml["spec"], { "enforcementAction" : var.dryrun_map.hostname_length ? "dryrun" : "deny" }) })
    external_dns_weight                = merge(local.external_dns_weight_yaml, { "spec" : merge(local.external_dns_weight_yaml["spec"], { "enforcementAction" : var.dryrun_map.external_dns_weight ? "dryrun" : "deny" }) })
    external_dns_identifier            = merge(local.external_dns_identifier_yaml, { "spec" : merge(local.external_dns_identifier_yaml["spec"], { "enforcementAction" : var.dryrun_map.external_dns_identifier ? "dryrun" : "deny", "parameters" : { "clusterColor" : var.cluster_color } }) })
    valid_hostname                     = merge(local.valid_hostname_yaml, { "spec" : merge(local.valid_hostname_yaml["spec"], { "enforcementAction" : var.dryrun_map.valid_hostname ? "dryrun" : "deny", "parameters" : { "validDomainNames" : "*.${var.cluster_domain_name},*.${var.integration_test_zone}" } }) })
    warn_service_account_secret_delete = merge(local.warn_service_account_secret_delete_yaml, { "spec" : merge(local.warn_service_account_secret_delete_yaml["spec"], { "enforcementAction" : var.dryrun_map.warn_service_account_secret_delete ? "dryrun" : "warn" }) })
    user_ns_requires_psa_label         = merge(local.user_ns_requires_psa_label_yaml, { "spec" : merge(local.user_ns_requires_psa_label_yaml["spec"], { "enforcementAction" : var.dryrun_map.user_ns_requires_psa_label ? "dryrun" : "deny" }) })
  }
}
