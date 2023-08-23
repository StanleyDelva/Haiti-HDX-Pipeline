terraform {
    required_version = ">=1.0"
    backend "local" {}
    required_providers {
        google = {
            source = "hashicorp/google"
        }
    }
}

provider "google" {
    project = var.project_id
    region = var.region
    credentials = file(var.gcp_credentials) #use this if you don't want to set env-var GOOGLE_APPLICATION
}

# GCS storage bucket
resource "google_storage_bucket" "haiti_data_lake" {
  name          = var.bucket_name
  location      = var.region

  # Optional, but recommended settings:
  storage_class = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  force_destroy = true
}

# Bigquery dataset
resource "google_bigquery_dataset" "haiti_idp_dataset" {
  dataset_id = var.dataset_name
  project    = var.project_id
  location   = var.region
}

# Artifact registry for containers
resource "google_artifact_registry_repository" "haiti-container-registry" {
  location      = var.region
  repository_id = var.registry_id
  format        = "DOCKER"
}