locals {
  constraint_map = {
    service_type               = merge(yamldecode(file("${path.module}/resources/constraints/service_type.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.service_type ? "dryrun" : "deny" } })
    snippet_allowlist          = merge(yamldecode(file("${path.module}/resources/constraints/snippet_allowlist.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.snippet_allowlist ? "dryrun" : "deny" } })
    modsec_snippet_nginx_class = merge(yamldecode(file("${path.module}/resources/constraints/modsec_snippet_nginx_class.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.modsec_snippet_nginx_class ? "dryrun" : "deny" } })
    modsec_nginx_class         = merge(yamldecode(file("${path.module}/resources/constraints/modsec_nginx_class.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.modsec_nginx_class ? "dryrun" : "deny" } })
    ingress_clash              = merge(yamldecode(file("${path.module}/resources/constraints/ingress_clash.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.ingress_clash ? "dryrun" : "deny" } })
    hostname_length            = merge(yamldecode(file("${path.module}/resources/constraints/ingress_hostname_length.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.hostname_length ? "dryrun" : "deny" } })
  }
}
