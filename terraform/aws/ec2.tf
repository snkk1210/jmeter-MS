module "ec2" {
  source = "./modules/ec2"

  # Number of Controller
  c_number = var.c_number
  # Number of Worker
  w_number = var.w_number

  # Whether to provision Controller or not
  enable_c_provision = var.enable_c_provision
  # Whether to provision Worker or not
  enable_w_provision = var.enable_w_provision

  # Controller Server Connection IP
  security_group_rules_controller = var.security_group_rules_controller

  # Worker Server Connection IP
  security_group_rules_worker = var.security_group_rules_worker

  # default: Almalinux8
  ami = var.ami
  # m5.large or larger recommended
  instance_type = var.instance_type

  common = {
    project     = var.project
    environment = var.environment
  }

  vpc_cidr                    = module.network.vpc_cidr
  vpc_id                      = module.network.vpc_id
  subnet_ids                  = module.network.public_subnet_ids
  associate_public_ip_address = true
  root_block_device = {
    "volume_type"           = "gp2"
    "volume_size"           = var.volume_size
    "delete_on_termination" = true
    "encrypted"             = true
  }
}