/** 
# Public Subnet
*/
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_az1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-public-subnet-${substr(var.az1, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_az2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-public-subnet-${substr(var.az2, -2, -2)}${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Internet Gateway
*/
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-igw${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

/** 
# Route Table ( Public )
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.common.project}- ${var.common.environment}-public-rt${var.sfx}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}