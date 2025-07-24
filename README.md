# EKS IaC Pipeline MVP

This repository contains an MVP (Minimum Viable Product) pipeline for managing Amazon EKS (Elastic Kubernetes Service) clusters using Infrastructure as Code (IaC). The solution leverages Terraform for infrastructure definition and GitHub Actions for CI/CD, demonstrating multi-environment deployments, basic versioning, and automated testing principles.

## Objective

The primary objective is to build a robust and automated pipeline to provision and manage an AWS EKS cluster, showcasing best practices in IaC, multi-environment propagation, and infrastructure testing.

## Technologies Used

* **IaC:** Terraform (with `terraform-aws-modules/eks/aws` and `terraform-aws-modules/vpc/aws`)
* **CI/CD:** GitHub Actions
* **Cloud Provider:** AWS
* **Testing:** Terratest (Go)
* **Linting/Static Analysis:** `terraform validate`, `tflint`

## Repository Structure

├── .github/                 # GitHub Actions Workflows
│   └── workflows/
│       ├── dev-pipeline.yml   # Deploys to 'dev' environment
│       ├── test-pipeline.yml  # Deploys to 'test' environment
│       └── prod-pipeline.yml  # Deploys to 'prod' environment (manual approval)
├── terraform/               # Terraform IaC Configurations
│   ├── modules/
│   │   ├── eks-cluster/     # Reusable module for EKS cluster
│   │   └── vpc/             # Reusable module for VPC
│   ├── environments/
│   │   ├── dev/             # 'dev' environment specific configuration
│   │   ├── test/            # 'test' environment specific configuration
│   │   └── prod/            # 'prod' environment specific configuration
│   └── shared/              # Common Terraform configurations (e.g., S3 backend)
├── tests/
│   └── terratest/           # Integration tests using Terratest
│       └── eks_test.go
├── scripts/
│   └── validate_and_plan.sh # Script for running Terraform validation and plan
├── README.md                # This README
└── .gitignore               # Files to ignore in Git

## Setup and Prerequisites

1.  **AWS Account(s):** You will need AWS credentials configured for GitHub Actions. It's recommended to use separate AWS accounts for `dev`, `test`, and `prod` for true isolation. For this MVP, you could use different regions or VPCs within a single account, but separate accounts are best practice.
    * Set up AWS credentials as GitHub Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` for each environment. Alternatively, configure OpenID Connect (OIDC) for GitHub Actions for more secure, temporary credentials.
2.  **GitHub Repository:** Fork or clone this repository to your GitHub account.
3.  **S3 Bucket for Terraform State:** Create a single S3 bucket to store your Terraform state files, with versioning enabled. Also, create a DynamoDB table for state locking.
    * Example: `my-eks-iac-tfstate-bucket` (S3 Bucket)
    * Example: `my-eks-iac-tf-lock` (DynamoDB Table with `LockID` as primary key)
    * Update `terraform/shared/backend.tf` with your bucket and table names.
4.  **Terraform CLI:** Install Terraform CLI locally for development and testing. (`>= 1.5.7`)
5.  **Go:** Install Go locally if you want to run Terratest. (`>= 1.20`)
6.  **`tflint`:** Install `tflint` for static analysis.

## Usage

### 1. Configure Terraform Backend

Update `terraform/shared/backend.tf` with your S3 bucket name and DynamoDB table name for Terraform state management.

### 2. Configure Environment Variables

Navigate to `terraform/environments/dev/terraform.tfvars`, `terraform/environments/test/terraform.tfvars`, and `terraform/environments/prod/terraform.tfvars` and adjust the variables (e.g., `cluster_name`, `instance_type`, `desired_size`, `region`, `account_id`) to match your desired configurations for each environment.

**Important:** For production, it's highly recommended to use a separate AWS account ID.

### 3. Commit and Push

* Push your changes to the `main` branch (or a feature branch that merges into `main`).
* The GitHub Actions workflows are configured to deploy based on pushes to specific branches (`dev`, `test`, `main`).

### 4. Observe GitHub Actions

* **`dev-pipeline.yml`**: Automatically triggers on push to the `dev` branch. It will run `terraform validate`, `tflint`, `terraform plan`, and `terraform apply` for the `dev` environment.
* **`test-pipeline.yml`**: Automatically triggers on push to the `test` branch. It will follow similar steps for the `test` environment.
* **`prod-pipeline.yml`**: Triggers on push to the `main` branch (representing production). This pipeline includes a **manual approval step** before `terraform apply` is executed, demonstrating a controlled promotion process.

### 5. Running Terratest (Optional, Local)

For integration testing of your IaC, you can run Terratest locally.

1.  Navigate to `tests/terratest`.
2.  Ensure you have AWS credentials configured locally (e.g., via `~/.aws/credentials` or environment variables).
3.  Run the tests:
    ```bash
    go mod init [github.com/](https://github.com/)<your-username>/your-eks-iac-repo/tests/terratest
    go mod tidy
    go test -v -timeout 30m eks_test.go
    ```
    * **Note:** Terratest will provision real resources in your AWS account and then destroy them. This will incur costs. Adjust the `cluster_name_prefix` in `eks_test.go` to avoid conflicts.

## Evaluation Criteria Highlights

* **Core Requirement (MVP Pipeline):** Demonstrated through the GitHub Actions workflows (`dev-pipeline.yml`, `test-pipeline.yml`, `prod-pipeline.yml`) that perform `terraform init`, `plan`, and `apply`.
* **Complex Resource (EKS):** The `terraform/modules/eks-cluster` clearly defines a complex EKS cluster, including VPC, subnets, node groups, and associated IAM roles.
* **Configuration Propagation (dev → test → prod):**
    * Separate directories (`terraform/environments/dev`, `test`, `prod`) and `terraform.tfvars` files handle environment-specific configurations.
    * GitHub Actions workflows are branched (`dev` branch -> dev env, `test` branch -> test env, `main` branch -> prod env) to simulate promotion.
    * The `prod-pipeline.yml` includes an explicit approval step.
* **Versioning:** Git serves as the primary versioning mechanism. Each commit represents a version of your infrastructure. Tags (e.g., `v1.0.0`) can be used to mark specific stable states.
* **Breaking Change Detection:**
    * `terraform validate` and `tflint` are integrated into the CI pipelines (`scripts/validate_and_plan.sh`) to catch syntax errors and best practice violations pre-deployment.
    * The `terraform plan` output in the CI/CD logs provides a preview of changes, allowing for human review to detect unintended breaking changes before `apply`.
* **Automated Testing:**
    * **Static Analysis:** `tflint` is used in the `validate_and_plan.sh` script.
    * **Integration Testing:** `tests/terratest/eks_test.go` provides an example of how to provision a temporary EKS cluster and run basic assertions against it to ensure core functionality.

## Future Enhancements

* **Cost Optimization:** Integrate cost-awareness tools or policies.
* **Advanced Observability:** Set up detailed EKS logging to CloudWatch, integrate with Prometheus/Grafana.
* **Security Scanning:** Integrate tools like `checkov` or `tfsec` for security best practices.
* **Secrets Management:** Use AWS Secrets Manager or HashiCorp Vault for sensitive data.
* **GitOps:** Integrate with FluxCD or ArgoCD for continuous delivery of Kubernetes applications *to* the EKS cluster.
* **Terraform Cloud/Enterprise:** For larger teams, consider HashiCorp Terraform Cloud/Enterprise for advanced state management, collaboration, and policy enforcement.
* **Rollback Strategy:** Implement explicit rollback capabilities (e.g., reverting to a previous Git tag and reapplying, or using Terraform's state manipulation carefully).
# mc-iac-eks
