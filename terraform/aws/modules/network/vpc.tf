/** 
# VPC
*/
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-vpc${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}