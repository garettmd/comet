terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }

  backend "gcs" {
    bucket = "comet-test-tf-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  # project = var.project_id
  # region  = var.region
}