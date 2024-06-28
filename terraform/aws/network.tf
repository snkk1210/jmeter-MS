module "network" {
  source = "./modules/network"

  common = {
    project     = var.project
    environment = var.environment
  }
}