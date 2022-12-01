resource "google_cloudbuild_trigger" "cloudbuild-master" {
  name            = "test"
  description     = "test"
  location = "europe-central2"
  github {
    owner = var.owner
    name  = var.repo_name

    push {
      branch       = "^(master|main)$"
      invert_regex = false
    }
  }
  filename      = "cloudbuild.yaml"
}
