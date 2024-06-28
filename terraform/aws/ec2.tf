module "ec2" {
  source = "./modules/ec2"

  # Number of Controller
  c_number = 1
  # Number of Worker
  w_number = 2

  # Whether to provision Controller or not
  enable_c_provision = true
  # Whether to provision Worker or not
  enable_w_provision = true

  # Controller Server Connection IP
  security_group_rules_controller = [
    "xxx.xxx.xxx.xxx/32",
  ]

  # Worker Server Connection IP
  security_group_rules_worker = [
    "xxx.xxx.xxx.xxx/32",
  ]

  # default: Almalinux8
  ami = "ami-0b299c22ffb336d85"
  # m5.large or larger recommended
  instance_type = "m5.large"

  common = {
    project = var.project
    environment = var.environment
  }

  vpc_cidr                    = module.network.vpc_cidr
  vpc_id                      = module.network.vpc_id
  subnet_ids                  = module.network.public_subnet_ids
  associate_public_ip_address = true
  root_block_device = {
    "volume_type"           = "gp2"
    "volume_size"           = 30
    "delete_on_termination" = true
    "encrypted"             = true
  }
}