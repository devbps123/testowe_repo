output "security_writer_identity_sa_id" {
  value = trim(module.security_log_export.writer_identity,"serviceAccount:")
}
output "analitics_writer_identity_sa_id" {
  value = trim(module.analitics_log_export.writer_identity,"serviceAccount:")
}
output "application_writer_identity_sa_id" {
  value = trim(module.application_log_export.writer_identity,"serviceAccount:")
}