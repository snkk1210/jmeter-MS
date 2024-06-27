/** 
# Isolated Subnet
*/
resource "aws_subnet" "isolated_az1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.isolated_az1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-isolated-subnet-${substr(var.az1, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "isolated_az2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.isolated_az2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-isolated-subnet-${substr(var.az2, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Route Table ( Isolated )
*/
resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-isolated-rt${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route_table_association" "isolated_az1" {
  subnet_id      = aws_subnet.isolated_az1
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "isolated_az2" {
  subnet_id      = aws_subnet.isolated_az2
  route_table_id = aws_route_table.isolated.id
}