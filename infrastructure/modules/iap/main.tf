resource "google_project_service" "service" {
  count                      = length(var.project_services)
  project                    = var.project
  service                    = element(var.project_services, count.index)
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_iap_brand" "framecube_brand" {
  support_email = "maciej.pietrzykowski@getindata.com"
  application_title = "framecube"
  project = var.project
  }
resource "google_iap_client" "framecube_client" {
  display_name = "Oauth framecube client"
  brand = google_iap_brand.framecube_brand.name
}

resource "google_secret_manager_secret" "framecube_iap_client_id" {
  secret_id = "framecube-iap-client-id"
  project = var.project
  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.service]
}

resource "google_secret_manager_secret" "framecube_iap_secret" {
  secret_id = "framecube-iap-secret"
  project = var.project
  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.service]
}

resource "google_secret_manager_secret_version" "secret_framecube_iap_client_id" {
  secret = google_secret_manager_secret.framecube_iap_client_id.id
  secret_data = google_iap_client.framecube_client.client_id
}
resource "google_secret_manager_secret_version" "secret_framecube_iap_secret_id" {
  secret = google_secret_manager_secret.framecube_iap_secret.id
  secret_data = google_iap_client.framecube_client.secret
}