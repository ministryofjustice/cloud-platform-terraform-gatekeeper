# Testing ConstraintTemplates and Constraints using gator CLI

gator is Gatekeepers tool for evaluation of ContraintTemplate & Constraints against kubernetes resources.

## Installing gator:

https://open-policy-agent.github.io/gatekeeper/website/docs/gator/#installation

## Example use

verify sub-command is used to run a test suite, which is defined like following:

```
kind: Suite
apiVersion: test.gatekeeper.sh/v1alpha1
tests:
- name: allowed-namespaces
  template: ../label-template.yaml
  constraint: ../label-constraint.yaml
  cases:
  - name: namespace-allowed
    object: samples/valid-namespace.yaml
    assertions:
    - violations: no
  - name: namespace-disallowed
    object: samples/invalid-namespace.yaml
    assertions:
    - violations: yes
```

Execute test with:

`$ gator verify label-suite.yaml`

```
ok      cloud-platform-terraform-gatekeeper/constraints/tests/label-suite.yaml 0.013s
PASS
```