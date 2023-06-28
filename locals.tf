locals {
  constraint_map = {
    service_type = merge(yamldecode(file("${path.module}/resources/constraints/service_type.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.service_type ? "dryrun" : "deny" } })
    snippet_allowlist = merge(yamldecode(file("${path.module}/resources/constraints/snippet_allowlist.yaml")), { "spec" : { "enforcementAction" : var.dryrun_map.snippet_allowlist ? "dryrun" : "deny" } })
  }
}
