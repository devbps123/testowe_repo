resource "google_compute_firewall" "bps-firewall-ssh" {
  name = "bps-ssh"
  network = var.network
  project = var.project
  priority = "65534"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = [
      "22" ]
  }
}
resource "google_compute_firewall" "bps-firewall-rdp" {
  name = "bps-rdp"
  network = var.network
  project = var.project
  priority = "65534"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = [
      "3389" ]
  }
}
resource "google_compute_firewall" "bps-firewall-icmp" {
  name = "bps-icmp"
  network = var.network
  project = var.project
  priority = "65534"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }
}
resource "google_compute_firewall" "healthcheck" {
  name          = "fw-allow-health-check"
  direction     = "INGRESS"
  network       = var.network
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80","443"]
    protocol = "tcp"
  }
}
resource "google_compute_firewall" "healthcheck2" {
  name          = "fw-allow-health-check2"
  direction     = "INGRESS"
  network       = "default"
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80","443"]
    protocol = "tcp"
  }
}