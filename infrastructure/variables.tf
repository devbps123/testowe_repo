variable "project" {
}
variable "credentials" {
  type = string
}
variable "region" {
  default = "europe-central2"
}
variable "zone" {
  default = "europe-central2-a"
}
variable "storage-class" {
  default = "REGIONAL"
}
variable "domain_name" {
  default = "dwh.mojbank.pl"
}
variable "lb_domain_name" {
  default = "direct.dwh.mojbank.pl"
}