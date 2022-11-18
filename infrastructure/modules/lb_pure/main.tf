#dla wlasnego certyfikatu odkomentowac modul i podmienic zawartosc plikow test.key oraz test.crt
resource "google_compute_ssl_certificate" "bps_ssl_lb" {
name_prefix = "bps-ssl-"
private_key = file("modules/lb_pure/cert/test.key")
certificate = file("modules/lb_pure/cert/test.crt")

lifecycle {
create_before_destroy = true
 }
}

#resource "google_compute_managed_ssl_certificate" "lb_cert" {
#  provider = google-beta
#  name     = "framecube-ssl-cert-2"
#  project = var.project
#  managed {
#    domains = [var.domain_name]
#  }
#}
resource "google_compute_instance_template" "vm-template" {
  name = "lb-backend-vm-template"
  disk {
    auto_delete  = true
    boot         = true
    device_name  = "persistent-disk-0"
    mode         = "READ_WRITE"
    source_image = "projects/debian-cloud/global/images/family/debian-11"
    type         = "PERSISTENT"
  }
  labels = {
    managed-by-cnrm = "true"
  }
  machine_type = "n1-standard-1"
  metadata = {
    startup-script = "#! /bin/bash\n     sudo apt-get update\n     sudo apt-get install apache2 -y\n     sudo a2ensite default-ssl\n     sudo a2enmod ssl\n     vm_hostname=\"$(curl -H \"Metadata-Flavor:Google\" \\\n   http://169.254.169.254/computeMetadata/v1/instance/name)\"\n   sudo echo \"Page served from: $vm_hostname\" | \\\n   tee /var/www/html/index.html\n   sudo systemctl restart apache2"
  }
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    network    = var.vpc_name
    subnetwork = "regions/europe-central2/subnetworks/${var.vpc_name}"
  }
  region = var.region
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/pubsub", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }
  tags = ["allow-health-check"]
}

resource "google_compute_instance_group_manager" "lbvmgroup" {
  name = "lb-vm-backend"
  zone = var.zone
  named_port {
    name = "http"
    port = 80
  }
  named_port {
    name = "https"
    port = "443"
  }
  version {
    instance_template = google_compute_instance_template.vm-template.id
    name = "primary"
  }
  base_instance_name = "vm"
  target_size = 2
}
resource "google_compute_health_check" "lbfccheck" {
  name               = "https-basic-lb-check"
  check_interval_sec = 5
  healthy_threshold  = 2
  https_health_check {
    port               = 443
    port_specification = "USE_FIXED_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
  timeout_sec         = 5
  unhealthy_threshold = 2
}
resource "google_compute_backend_service" "lbbackend" {
  name                            = "backend-service"
  connection_draining_timeout_sec = 0
  health_checks                   = [google_compute_health_check.lbfccheck.id]
  load_balancing_scheme           = "EXTERNAL"
  port_name                       = "https"
  protocol                        = "HTTPS"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  backend {
    group           = google_compute_instance_group_manager.lbvmgroup.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
resource "google_compute_global_address" "lb-address" {
  name       = "lb-ipv4-2"
  ip_version = "IPV4"
}
resource "google_compute_url_map" "lburlmap" {
  name = "direct-https"
  default_service = google_compute_backend_service.lbbackend.id
  host_rule {
    hosts = [
      "direct.dwh.mojbank.pl"]
    path_matcher = "first"
  }
  path_matcher {
    name = "first"
    default_service = google_compute_backend_service.lbbackend.id
    path_rule {
      paths = [
        "/"]
      service = google_compute_backend_service.lbbackend.id
    }
  }
}
resource "google_compute_target_https_proxy" "lbhttpsproxytarget" {
  name    = "https-lb-proxy-pure"
  url_map = google_compute_url_map.lburlmap.id
  #ssl_certificates = [google_compute_managed_ssl_certificate.lb_cert.id]
  ssl_certificates = [google_compute_ssl_certificate.bps_ssl_lb.id]
}
resource "google_compute_global_forwarding_rule" "lbhttpscontentrule" {
  name                  = "lb-https-content-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443-443"
  target                = google_compute_target_https_proxy.lbhttpsproxytarget.id
  ip_address            = google_compute_global_address.lb-address.id
}
