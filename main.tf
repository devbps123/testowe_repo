resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
  project = "odnowa4-gid-poc-1930-sandbox"
}