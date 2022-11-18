provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.credentials
}
terraform {
  backend "gcs" {
    bucket  = "odnowa4-gid-poc-1930-sandbox-state"
    prefix  = "terraform/state"
  }
}