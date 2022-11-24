#Sterowanie
#parent_resource_id     = The ID of the GCP resource in which you create the log sink. If var.parent_resource_type is set to 'project', then this is the Project ID (and etc).
#parent_resource_type   The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing_account', or 'organization'.

module "security_log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.security_destination.destination_uri}"
  filter                 = <<EOT
(resource.type="service_account" AND log_id("cloudaudit.googleapis.com/activity") AND protoPayload.methodName="google.iam.admin.v1.CreateServiceAccount") OR
(resource.type="project" AND log_id("cloudaudit.googleapis.com/activity") AND protoPayload.methodName="SetIamPolicy")
EOT
  log_sink_name          = "security-sink"
  parent_resource_id     = var.project
  parent_resource_type   = "project"
  unique_writer_identity = true
}
module "security_destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = var.project
  storage_bucket_name      = "${var.project}-security"
  log_sink_writer_identity = "${module.security_log_export.writer_identity}"
  location = "europe-central2"
  storage_class = "standard"
}
module "application_log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.application_destination.destination_uri}"
  filter                 = <<EOT
(resource.type="gce_instance" AND log_id("cloudaudit.googleapis.com/activity")) OR
(resource.type="gce_instance" AND log_id("syslog")) OR
(resource.type="logging_sink" AND log_id("cloudaudit.googleapis.com/activity") AND protoPayload.methodName=("google.logging.v2.ConfigServiceV2.DeleteSink" OR "google.logging.v2.ConfigServiceV2.UpdateSink"))
EOT
  log_sink_name          = "application-sink"
  parent_resource_id     = var.project
  parent_resource_type   = "project"
  unique_writer_identity = true
}
module "application_destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = var.project
  storage_bucket_name      = "${var.project}-application"
  log_sink_writer_identity = "${module.application_log_export.writer_identity}"
  location = "europe-central2"
  storage_class = "standard"
}
module "analitics_log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.analitics_destination.destination_uri}"
  filter                 = <<EOT
/logs/cloudaudit.googleapis.com%2Factivity OR
/logs/cloudaudit.googleapis.com%2Fsystem_event
EOT
  log_sink_name          = "analitisc-sink"
  parent_resource_id     = var.project
  parent_resource_type   = "project"
  unique_writer_identity = true
}
module "analitics_destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = var.project
  storage_bucket_name      = "${var.project}-analitics"
  log_sink_writer_identity = "${module.analitics_log_export.writer_identity}"
  location = "europe-central2"
  storage_class = "standard"
}