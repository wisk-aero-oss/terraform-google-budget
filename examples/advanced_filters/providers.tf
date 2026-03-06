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
