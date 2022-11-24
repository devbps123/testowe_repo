locals {
  role = [
    "logging.configWriter",
    "resourcemanager.projectIamAdmin",
    "serviceusage.serviceUsageAdmin",
    "storage.admin",
    "bigquery.dataEditor"
  ]
}
