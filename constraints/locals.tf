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
  deprecated_apis_1_26_yaml               = yamldecode(file("${path.module}/../resources/constraints/deprecated_apis_1.26.yaml"))
  deprecated_apis_1_27_yaml               = yamldecode(file("${path.module}/../resources/constraints/deprecated_apis_1.27.yaml"))
  deprecated_apis_1_29_yaml               = yamldecode(file("${path.module}/../resources/constraints/deprecated_apis_1.29.yaml"))
  lock_priv_capabilities_yaml             = yamldecode(file("${path.module}/../resources/constraints/lock_priv_capabilities.yaml"))
  warn_kubectl_create_sa                  = yamldecode(file("${path.module}/../resources/constraints/warn_sa.yaml"))
  allow_duplicate_hostname_yaml           = yamldecode(file("${path.module}/../resources/constraints/ingress_allow_duplicate_hostname.yaml"))
  block_ingresses_yaml                    = yamldecode(file("${path.module}/../resources/constraints/block_ingresses.yaml"))

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
    deprecated_apis_1_26               = merge(local.deprecated_apis_1_26_yaml, { "spec" : merge(local.deprecated_apis_1_26_yaml["spec"], { "enforcementAction" : var.dryrun_map.deprecated_apis_1_26 ? "dryrun" : "deny" }) })
    deprecated_apis_1_27               = merge(local.deprecated_apis_1_27_yaml, { "spec" : merge(local.deprecated_apis_1_27_yaml["spec"], { "enforcementAction" : var.dryrun_map.deprecated_apis_1_27 ? "dryrun" : "deny" }) })
    deprecated_apis_1_29               = merge(local.deprecated_apis_1_29_yaml, { "spec" : merge(local.deprecated_apis_1_29_yaml["spec"], { "enforcementAction" : var.dryrun_map.deprecated_apis_1_29 ? "dryrun" : "deny" }) })
    lock_priv_capabilities             = merge(local.lock_priv_capabilities_yaml, { "spec" : merge(local.lock_priv_capabilities_yaml["spec"], { "enforcementAction" : var.dryrun_map.lock_priv_capabilities ? "dryrun" : "deny" }) })
    warn_kubectl_create_sa             = merge(local.warn_kubectl_create_sa, { "spec" : merge(local.warn_kubectl_create_sa["spec"], { "enforcementAction" : var.dryrun_map.warn_kubectl_create_sa ? "dryrun" : "warn" }) })
    allow_duplicate_hostname_yaml      = merge(local.allow_duplicate_hostname_yaml, { "spec" : merge(local.allow_duplicate_hostname_yaml["spec"], { "enforcementAction" : var.dryrun_map.allow_duplicate_hostname_yaml ? "dryrun" : "deny" }) })
    block_ingresses_yaml               = merge(local.block_ingresses_yaml, { "spec" : merge(local.block_ingresses_yaml["spec"], { "enforcementAction" : var.dryrun_map.block_ingresses ? "dryrun" : "deny" }) })
  }
}
