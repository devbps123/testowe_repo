resource "google_compute_network" "bpsnetwork" {
  name = var.vpc_name
  project = var.project
}
