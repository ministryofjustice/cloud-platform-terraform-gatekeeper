package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func Test(t *testing.T) {
	t.Parallel()

	terraformOptionsOnce := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
		Targets: []string{"helm_release.gatekeeper","kubernetes_namespace.gatekeeper"},
	})
	terraformOptionsTwice := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
	})

	defer terraform.Destroy(t, terraformOptionsTwice)

	terraform.InitAndApply(t, terraformOptionsOnce)
	terraform.InitAndApply(t, terraformOptionsTwice)
}
