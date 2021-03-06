terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("key-file")
  project     = var.GCP_PROJECT
  region      = var.region
}