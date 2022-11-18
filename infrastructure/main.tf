module "vpc" {
  source = "./modules/vpc"
  project = var.project
  vpc_name = "bps-vpc-${var.project}"
}
module "firewall" {
  depends_on = [module.vpc]
  source = "./modules/firewall"
  project = var.project
  network = module.vpc.vpc_name
}
module "iap" {
  source = "./modules/iap"
  project = var.project
}
module "lb-iap" {
  depends_on = [module.iap]
  source = "./modules/lb_iap"
  vpc_name = "bps-vpc-${var.project}"
  region = var.region
  zone = var.zone
  project = var.project
  oauth2_secret = module.iap.client_secret
  oauth2_client = module.iap.client_id
  domain_name = var.domain_name
}
module "lb-pure" {
  source = "./modules/lb_pure"
  vpc_name = "bps-vpc-${var.project}"
  region = var.region
  zone = var.zone
  project = var.project
  domain_name = var.lb_domain_name
}
