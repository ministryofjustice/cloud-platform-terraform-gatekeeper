# cloud-platform-terraform-gatekeeper

Kubernetes native security policy enforcement, an upgrade of https://github.com/ministryofjustice/cloud-platform-terraform-opa

## Usage


See the example/ subdir for invocation syntax

CAVEATS: 
 - to generate the audit report, it seems advisable to query a cache of filtered K8s objects, rather than hit the API each time (60 sec intervals default); because of that any kind used by a constraint template must also be added to the sync config at the end of constraints.tf
 - deleting a ConstraintTemplate that still has Constraints breaks things badly; only deleting the CRDs (which in turn removes all the constraints) unblocks again
 - no colons (:) in the description field

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.10.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.gatekeeper](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.config-sync](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/resources/manifest) | resource |
| [kubectl_manifest.unique-ingress-constraint](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/resources/manifest) | resource |
| [kubectl_manifest.unique-ingress-template](https://registry.terraform.io/providers/gavinbunney/kubectl/1.10.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.gatekeeper](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_domain_name"></a> [cluster\_domain\_name](#input\_cluster\_domain\_name) | The cluster domain used for externalDNS annotations and certmanager | `any` | n/a | yes |
| <a name="input_define_constraints"></a> [define\_constraints](#input\_define\_constraints) | if false, only the app is deployed, no constraints | `bool` | `true` | no |
| <a name="input_enable_invalid_hostname_policy"></a> [enable\_invalid\_hostname\_policy](#input\_enable\_invalid\_hostname\_policy) | Enable wheter to have the OPA policy of invalid hostname enabled | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidance](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |
| sqs_name |  | string | - | yes |

## Reading Material

[What is OPA Gatekeeper?](https://www.openpolicyagent.org/docs/latest/kubernetes-introduction/#what-is-opa-gatekeeper)
[OPA Gatekeeper Library](https://github.com/open-policy-agent/gatekeeper-library)
