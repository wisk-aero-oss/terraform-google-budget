# Custom Period Example

This example demonstrates how to create budgets that don't follow the standard monthly/quarterly calendar cycles.

## Key Features

- **Custom Dates:** Define explicit `start_date` and `end_date` for a budget period.
- **Multi-Currency:** Setting a budget in a non-USD currency (e.g., `EUR`).
- **Notification Control:** Disabling default IAM recipients while providing an alternative notification channel (mandatory for this configuration).

## Usage

1. Provide your billing account and notification channel details in `terraform.tfvars`.
2. Run `terraform init` and `terraform plan`.
