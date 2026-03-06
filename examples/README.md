# Module Usage Examples

This directory contains examples demonstrating different ways to use the `terraform-google-budget` module. Each example is a complete, standalone Terraform configuration.

## Available Examples

| Example                                    | Description                 | Key Features Demonstrated                                                 |
| :----------------------------------------- | :-------------------------- | :------------------------------------------------------------------------ |
| [**Basic**](./basic)                       | Standard budget setup.      | Human-readable Project IDs, Service Aliases, Notification Channels.       |
| [**Advanced Filters**](./advanced_filters) | Complex scoping rules.      | Labels, Resource Ancestors, Billing Subaccounts, Credit Type Treatments.  |
| [**Custom Period**](./custom_period)       | Non-standard intervals.     | Custom Start/End dates, non-USD currencies, disabling default recipients. |
| [**Dynamic Budget**](./dynamic_budget)     | Automated & Scalable logic. | `use_last_period_amount`, Pub/Sub topics, mixing IDs and Names.           |

## How to use these examples

1. Navigate to the example directory:

    ```bash
    cd examples/basic
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Review the execution plan:

    ```bash
    terraform plan
    ```

4. Apply the changes (requires GCP credentials):

    ```bash
    terraform apply
    ```

> **Note:** These examples require a `terraform.tfvars` file or environment variables to provide valid GCP identifiers like `billing_account_id` and `project_id`.
