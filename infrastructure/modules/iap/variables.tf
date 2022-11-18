variable "project" {
  type = string
}
variable "project_services" {
  type = list(string)
  default = [
    "iap.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}