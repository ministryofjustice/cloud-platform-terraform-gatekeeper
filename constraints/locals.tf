locals {
  # For each constraint, a value needs to be in the constraint map. This bloc allows us to set values on constraints which enables us to toggle the configuration of the constraints.
  constraint_map = {
    service_type                       = merge(yamldecode(file("${path.module}/../resources/constraints/service_type.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.service_type ? "dryrun" : "deny" } })
    snippet_allowlist                  = merge(yamldecode(file("${path.module}/../resources/constraints/snippet_allowlist.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.snippet_allowlist ? "dryrun" : "deny" } })
    modsec_snippet_nginx_class         = merge(yamldecode(file("${path.module}/../resources/constraints/modsec_snippet_nginx_class.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.modsec_snippet_nginx_class ? "dryrun" : "deny" } })
    modsec_nginx_class                 = merge(yamldecode(file("${path.module}/../resources/constraints/modsec_nginx_class.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.modsec_nginx_class ? "dryrun" : "deny" } })
    ingress_clash                      = merge(yamldecode(file("${path.module}/../resources/constraints/ingress_clash.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.ingress_clash ? "dryrun" : "deny" } })
    hostname_length                    = merge(yamldecode(file("${path.module}/../resources/constraints/ingress_hostname_length.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.hostname_length ? "dryrun" : "deny" } })
    external_dns_weight                = merge(yamldecode(file("${path.module}/../resources/constraints/ingress_external_dns_weight.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.external_dns_weight ? "dryrun" : "deny" } })
    external_dns_identifier            = merge(yamldecode(file("${path.module}/../resources/constraints/ingress_external_dns_identifier.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.external_dns_identifier ? "dryrun" : "deny", "parameters" : { "clusterColor" : var.cluster_color } } })
    valid_hostname                     = merge(yamldecode(file("${path.module}/../resources/constraints/ingress_valid_hostname.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.valid_hostname ? "dryrun" : "deny", "parameters" : { "validDomainNames" : "*.${var.cluster_domain_name},*.${var.integration_test_zone}" } } })
    warn_service_account_secret_delete = merge(yamldecode(file("${path.module}/../resources/constraints/warn_service_account_secret_delete.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.warn_service_account_secret_delete ? "dryrun" : "warn" } })
  }
}
