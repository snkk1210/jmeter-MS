module "network_ap-northeast-1" {
  source = "./modules/network/ap-northeast-1"

  project     = var.project
  cidr_prefix = var.cidr_prefix

}