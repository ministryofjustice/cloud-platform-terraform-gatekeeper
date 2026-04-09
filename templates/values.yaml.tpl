logLevel: INFO
constraintViolationsLimit: ${constraint_violations_max_to_display}
auditFromCache: ${audit_from_cache}
enableDeleteOperations: true
mutationAnnotations: true
postInstall:
  labelNamespace:
    enabled: ${post_install_label_namespace}
controllerManager:
  resources:
      limits:
        memory: ${controller_mem_limit}
      requests:
        cpu: 100m
        memory: ${controller_mem_req}
  exemptNamespaces: ["kube-system"]
  nodeSelector:
    cloud-platform.justice.gov.uk/system-ng: "true"
  tolerations:
    - key: "system-node"
      operator: "Equal"
      value: "true"
      effect: "NoSchedule"
audit:
  resources:
      limits:
        memory: ${audit_mem_limit}
      requests:
        cpu: 100m
        memory: ${audit_mem_req}
  nodeSelector:
    cloud-platform.justice.gov.uk/system-ng: "true"
  tolerations:
    - key: "system-node"
      operator: "Equal"
      value: "true"
      effect: "NoSchedule"
psp:
  enabled: false
