locals {
  service_type_yaml                       = yamldecode(file("${path.module}/../resources/constraints/service_type.yaml"))
  warn_service_account_secret_delete_yaml = yamldecode(file("${path.module}/../resources/constraints/warn_service_account_secret_delete.yaml"))
  user_ns_requires_psa_label_yaml         = yamldecode(file("${path.module}/../resources/constraints/user_ns_requires_psa_label.yaml"))
  lock_priv_capabilities_yaml             = yamldecode(file("${path.module}/../resources/constraints/lock_priv_capabilities.yaml"))
  warn_kubectl_create_sa                  = yamldecode(file("${path.module}/../resources/constraints/warn_sa.yaml"))
 
  # For each constraint, a value needs to be in the constraint map. This bloc allows us to set values on constraints which enables us to toggle the configuration of the constraints. -- we merge in the spec separately to avoid overwriting entire spec key
  constraint_map = {
    service_type                       = merge(local.service_type_yaml, { "spec" : merge(local.service_type_yaml["spec"], { "enforcementAction" : var.dryrun_map.service_type ? "dryrun" : "deny" }) })
    warn_service_account_secret_delete = merge(local.warn_service_account_secret_delete_yaml, { "spec" : merge(local.warn_service_account_secret_delete_yaml["spec"], { "enforcementAction" : var.dryrun_map.warn_service_account_secret_delete ? "dryrun" : "warn" }) })
    user_ns_requires_psa_label         = merge(local.user_ns_requires_psa_label_yaml, { "spec" : merge(local.user_ns_requires_psa_label_yaml["spec"], { "enforcementAction" : var.dryrun_map.user_ns_requires_psa_label ? "dryrun" : "deny" }) })
    lock_priv_capabilities             = merge(local.lock_priv_capabilities_yaml, { "spec" : merge(local.lock_priv_capabilities_yaml["spec"], { "enforcementAction" : var.dryrun_map.lock_priv_capabilities ? "dryrun" : "deny" }) })
    warn_kubectl_create_sa             = merge(local.warn_kubectl_create_sa, { "spec" : merge(local.warn_kubectl_create_sa["spec"], { "enforcementAction" : var.dryrun_map.warn_kubectl_create_sa ? "dryrun" : "warn" }) })
  }
}
