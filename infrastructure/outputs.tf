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