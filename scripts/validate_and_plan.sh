#!/bin/bash

# This script performs Terraform validation and a plan.
# It's designed to be run in a CI/CD environment.

set -e # Exit immediately if a command exits with a non-zero status.

# Variables passed from GitHub Actions
TF_WORKING_DIR=$1
ENVIRONMENT=$2

echo "--- Validating and Planning for environment: ${ENVIRONMENT} in directory: ${TF_WORKING_DIR} ---"

cd "${TF_WORKING_DIR}"

echo "Initializing Terraform..."
terraform init -backend-config="../../../terraform/shared/backend.tf"

echo "Running TFLint..."
# Use tflint to check for best practices and errors
# Customize .tflint.hcl for specific rules
tflint --init
tflint --enable-rule=terraform_standard --enable-rule=aws_instance_no_public_ip

echo "Formatting Terraform code..."
terraform fmt -check -recursive # Ensure code is formatted correctly

echo "Validating Terraform configuration..."
terraform validate

echo "Generating Terraform plan..."
# -detailed-exitcode is useful for CI to differentiate between no changes (0), changes (2), and errors (1)
terraform plan -out=tfplan -detailed-exitcode

PLAN_EXIT_CODE=$?

if [ $PLAN_EXIT_CODE -eq 0 ]; then
  echo "Terraform Plan: No changes detected."
elif [ $PLAN_EXIT_CODE -eq 2 ]; then
  echo "Terraform Plan: Changes detected. Review the plan above."
else
  echo "Terraform Plan: An error occurred. Please check the logs."
  exit 1
fi

echo "--- Validation and Plan Complete for ${ENVIRONMENT} ---"

# The tfplan file is created and can be used by the apply step