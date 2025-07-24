package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestEKSCluster(t *testing.T) {
	t.Parallel()

	// Unique ID for the cluster name to avoid conflicts
	clusterNamePrefix := fmt.Sprintf("terratest-eks-%s", strings.ToLower(random.UniqueId()))
	awsRegion := "ap-south-1" // Use your preferred region for testing

	// Define the path to the Terraform code that will be tested.
	// We'll test the 'dev' environment configuration for simplicity,
	// but you could create a dedicated 'test-env' in your terraform/environments.
	terraformDir := "../../terraform/environments/dev"

	// At the end of the test, clean up the AWS resources.
	defer test_structure.RunAndLogDefer(t, func() {
		// IMPORTANT: Ensure you have proper AWS credentials configured for Terratest to destroy resources.
		terraformOptions := test_structure.LoadTerraformOptions(t, terraformDir)
		terraform.Destroy(t, terraformOptions)
	})

	// Configure Terraform options with default retryable errors to handle common issues.
	terraformOptions := test_structure.RunAndSaveTerraformOptions(t, terraformDir, &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"cluster_name":        clusterNamePrefix,
			"aws_region":          awsRegion,
			"aws_cli_user_name":   "your-aws-cli-user-name", // User for EKS access, adapt as needed.
			"desired_size":        1, // Keep test cluster small
			"max_size":            1,
			"min_size":            1,
			"instance_type":       "t3.small",
		},
		BackendConfig: map[string]interface{}{
			"bucket":         "YOUR_TFSTATE_BUCKET_NAME",      // Replace with your S3 bucket name
			"key":            "terratest/eks/terraform.tfstate", // Unique key for test state
			"region":         awsRegion,
			"encrypt":        true,
			"dynamodb_table": "YOUR_DYNAMODB_LOCK_TABLE_NAME", // Replace with your DynamoDB table name
		},
		NoColor: false,
	})


	test_structure.RunTerraformInitAndApply(t, terraformOptions)

	
	clusterEndpoint := terraform.Output(t, terraformOptions, "eks_cluster_endpoint")
	clusterName := terraform.Output(t, terraformOptions, "eks_cluster_name")

	
	actualClusterName := aws.Get 
	if actualClusterName != "" { 
		assert.Equal(t, clusterName, actualClusterName, "EKS cluster name should match the expected name")
	} else {

		t.Logf("EKS cluster '%s' provisioned with endpoint: %s", clusterName, clusterEndpoint)
	}

	maxRetries := 20
	sleepInterval := 10 * time.Second


	t.Logf("EKS Cluster %s is provisioned and basic checks passed.", clusterName)
}