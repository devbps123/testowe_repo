terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.44.1"
    }
    github = {
      source = "integrations/github"
      version = "5.10.0"
    }
  }
}

