# Advanced Filters Example

This example demonstrates how to scope a budget using granular filters beyond just projects and services.

## Key Features

- **Label Filtering:** Scopes costs to resources with specific labels (e.g., `environment = production`).
- **Resource Ancestors:** Includes costs from specific folders or organizations.
- **Subaccounts:** Filters by Billing Subaccount display names.
- **Credit Treatment:** Shows how to include or exclude specific credits (like Free Tier or Discounts).

## Usage

1. Provide your billing account and subaccount identifiers in `terraform.tfvars`.
2. Run `terraform init` and `terraform plan`.
