# Basic Budget Example

This example demonstrates the most common usage of the module: creating a simple monthly budget for a specific project and service.

## Key Features

- **Project IDs:** Uses `my-project-id` instead of numeric project numbers.
- **Service Aliases:** Uses `BigQuery` and `Compute Engine` instead of hex Service IDs.
- **Notification Channels:** Links alerts using display names (`Test Channel`) instead of resource paths.

## Usage

1. Provide your billing account and project ID in `terraform.tfvars`.
2. Run `terraform init` and `terraform plan`.
