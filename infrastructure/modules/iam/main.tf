resource "google_project_iam_member" "analitics_sa_binding" {
  count = length(local.role)
  project = var.project
  role = "roles/${local.role[count.index]}"
  member = "serviceAccount:${var.analitics_sa}"
}
resource "google_project_iam_member" "security_sa_binding" {
  count = length(local.role)
  project = var.project
  role = "roles/${local.role[count.index]}"
  member = "serviceAccount:${var.security_sa}"
}
resource "google_project_iam_member" "application_sa_binding" {
  count = length(local.role)
  project = var.project
  role = "roles/${local.role[count.index]}"
  member = "serviceAccount:${var.application_sa}"
}
