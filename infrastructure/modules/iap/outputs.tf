output "client_id" {
  value = google_secret_manager_secret_version.secret_framecube_iap_client_id.secret_data
}
output "client_secret" {
  value = google_secret_manager_secret_version.secret_framecube_iap_secret_id.secret_data
}