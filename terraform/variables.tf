variable "project_id" {
  type= string
  description = "GCS project ID"
}

variable "bucket_name" {
    type =string
    description= "Name of Google Storage Bucket to create"
}

variable "gcp_credentials" {
  type = string
  sensitive = true
  description = "Google Cloud service account credentials JSON file"
}

variable "region" {
  type = string
  description = "Region for GCP resources"
  default = "us-east4"
}

variable "storage_class" {
  type = string
  description = "Storage class type for bucket."
  default = "STANDARD"
}

variable "dataset_name" {
  type = string
  description = "BigQuery dataset to create"
}


variable "registry_id" {
  type = string
  description = "Name of artifact registry repository."
}


