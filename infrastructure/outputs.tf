output "vpc_name" {
  value = module.vpc.vpc_name
}
output "client_id" {
  value = module.iap.client_id
  sensitive = true
}
output "client_secret" {
  value = module.iap.client_secret
  sensitive = true
}
output "security_writer_identity_sa_id" {
  value = module.logs.security_writer_identity_sa_id
}
output "analitics_writer_identity_sa_id" {
  value = module.logs.analitics_writer_identity_sa_id
}
output "application_writer_identity_sa_id" {
  value = module.logs.application_writer_identity_sa_id
}