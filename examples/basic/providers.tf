terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.35.0"
    }
  }
}
# In a local development environment, the provider will use credentials obtained with:
# 'gcloud auth application-default login'
provider "google" {
}

# Example: CI/CD Workload Identity Federation (OIDC) Configuration
# This is the standard way to run this module in a secure CI/CD runner.
#
# provider "google" {
#   # The Workload Identity Provider name
#   # e.g., projects/<project_number>/locations/global/workloadIdentityPools/<pool_id>/providers/<provider_id>
#   workload_identity_provider = "projects/000000000000/locations/global/workloadIdentityPools/your-pool/providers/your-provider"
#
#   # The Service Account the runner is authorized to impersonate
#   service_account = "terraform-sa@your-project-id.iam.gserviceaccount.com"
# }
