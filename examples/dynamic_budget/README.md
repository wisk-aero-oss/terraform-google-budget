# Dynamic Budget Example

This example demonstrates more advanced, automated budgeting patterns suitable for dynamic environments.

## Key Features

- **Automatic Budgeting:** Uses `use_last_period_amount = true` to automatically set the budget based on previous spend.
- **Pub/Sub Integration:** Sends alerts directly to a Pub/Sub topic for automated remediation.
- **Mixed Identifiers:** Shows how the module handles a mix of full resource IDs and short names in the same list.
- **Project-Level Alerts:** Enables notifications to be sent to project-level owners.

## Usage

1. Provide your billing account and Pub/Sub details in `terraform.tfvars`.
2. Run `terraform init` and `terraform plan`.
