package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestProxmoxFileBasic tests basic file upload with snippet content type
func TestProxmoxFileBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	fileOutput := terraform.OutputJson(t, terraformOptions, "file")

	// Assert that the output is not empty
	assert.NotEmpty(t, fileOutput, "File output should not be empty")
	assert.Contains(t, fileOutput, "test_snippet", "File output should contain test_snippet key")
}

// TestProxmoxFileSnippet tests snippet upload with raw data
func TestProxmoxFileSnippet(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/snippet",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	fileOutput := terraform.OutputJson(t, terraformOptions, "file")

	// Assert that the output is not empty
	assert.NotEmpty(t, fileOutput, "File output should not be empty")
	assert.Contains(t, fileOutput, "cloud_init", "File output should contain cloud_init key")
}

// TestProxmoxFileMultiple tests multiple file uploads with different content types
func TestProxmoxFileMultiple(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/multiple",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	fileOutput := terraform.OutputJson(t, terraformOptions, "file")

	// Assert that the output is not empty
	assert.NotEmpty(t, fileOutput, "File output should not be empty")
	assert.Contains(t, fileOutput, "snippet1", "File output should contain snippet1 key")
	assert.Contains(t, fileOutput, "snippet2", "File output should contain snippet2 key")
}

// TestProxmoxFilePlanOnly tests that terraform plan runs without errors
func TestProxmoxFilePlanOnly(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
		PlanFilePath: "./plan",
	}

	// Run "terraform init" and "terraform plan"
	terraform.Init(t, terraformOptions)

	// This will save the plan to the PlanFilePath
	exitCode := terraform.Plan(t, terraformOptions)

	// Assert that the plan was successful (exit code 0 or 2)
	// Exit code 2 means there are changes to apply (expected)
	assert.Contains(t, []int{0, 2}, exitCode, "Terraform plan should complete successfully")
}

// TestProxmoxFileValidation tests input validation
func TestProxmoxFileValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	}

	// Run "terraform init" to install providers
	terraform.Init(t, terraformOptions)

	// Run "terraform validate" to check configuration syntax
	terraform.Validate(t, terraformOptions)
}

// TestProxmoxFileWithChecksum tests file upload with checksum validation
func TestProxmoxFileWithChecksum(t *testing.T) {
	t.Skip("Skipping test that requires actual file download - enable for integration testing")
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/checksum",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	fileOutput := terraform.OutputJson(t, terraformOptions, "file")

	// Assert that the output is not empty
	assert.NotEmpty(t, fileOutput, "File output should not be empty")
}

// TestProxmoxFileContentTypeValidation tests content_type validation
func TestProxmoxFileContentTypeValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/content_types",
		NoColor:      true,
	})

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)

	// Validate outputs
	fileOutput := terraform.OutputJson(t, terraformOptions, "file")

	// Assert that the output is not empty
	assert.NotEmpty(t, fileOutput, "File output should not be empty")
}
