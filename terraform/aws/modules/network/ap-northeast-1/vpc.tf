resource "aws_vpc" "common" {
  cidr_block           = "${var.cidr_prefix}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-jmeter-vpc"
  }
}

/**
# Public Sunbet
*/
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.0.0/22"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  tags = {
    Name = "${var.project}-jmeter-public-subnet-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.4.0/22"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "${var.project}-jmeter-public-subnet-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.8.0/22"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1d"
  tags = {
    Name = "${var.project}-jmeter-public-subnet-1d"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.project}-jmeter-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.project}-jmeter-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_1d" {
  subnet_id      = aws_subnet.public_1d.id
  route_table_id = aws_route_table.public_route_table.id
}

/**
# dmz Sunbet

resource "aws_eip" "eip_nat_gateway_1a" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.project}-jmeter-natgw-eip-1a"
  }
}

resource "aws_eip" "eip_nat_gateway_1c" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.project}-jmeter-natgw-eip-1c"
  }
}

resource "aws_eip" "eip_nat_gateway_1d" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.project}-jmeter-natgw-eip-1d"
  }
}

resource "aws_nat_gateway" "nat_gateway_1a" {
  allocation_id = aws_eip.eip_nat_gateway_1a.id
  subnet_id     = aws_subnet.public_1a.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.project}-jmeter-natgw-1a"
  }
}

resource "aws_nat_gateway" "nat_gateway_1c" {
  allocation_id = aws_eip.eip_nat_gateway_1c.id
  subnet_id     = aws_subnet.public_1c.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.project}-jmeter-natgw-1c"
  }
}

resource "aws_nat_gateway" "nat_gateway_1d" {
  allocation_id = aws_eip.eip_nat_gateway_1d.id
  subnet_id     = aws_subnet.public_1d.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "${var.project}-jmeter-natgw-1d"
  }
}

resource "aws_subnet" "dmz_1a" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.12.0/22"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-jmeter-dmz-subnet-1a"
  }
}

resource "aws_subnet" "dmz_1c" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.16.0/22"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-jmeter-dmz-subnet-1c"
  }
}

resource "aws_subnet" "dmz_1d" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.20.0/22"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-jmeter-dmz-subnet-1d"
  }
}

resource "aws_route_table" "dmz_1a" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.project}-jmeter-dmz-rt-1a"
  }
}

resource "aws_route_table" "dmz_1c" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.project}-jmeter-dmz-rt-1c"
  }
}

resource "aws_route_table" "dmz_1d" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.project}-jmeter-dmz-rt-1d"
  }
}

resource "aws_route_table_association" "dmz_1a" {
  subnet_id      = aws_subnet.dmz_1a.id
  route_table_id = aws_route_table.dmz_1a.id
}

resource "aws_route_table_association" "dmz_1c" {
  subnet_id      = aws_subnet.dmz_1c.id
  route_table_id = aws_route_table.dmz_1c.id
}

resource "aws_route_table_association" "dmz_1d" {
  subnet_id      = aws_subnet.dmz_1d.id
  route_table_id = aws_route_table.dmz_1d.id
}

resource "aws_route" "dmz_1a" {
  route_table_id         = aws_route_table.dmz_1a.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "dmz_1c" {
  route_table_id         = aws_route_table.dmz_1c.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1c.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "dmz_1d" {
  route_table_id         = aws_route_table.dmz_1d.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1d.id
  destination_cidr_block = "0.0.0.0/0"
}
*/

/**
# Private Sunbet
*/
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.24.0/22"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-jmeter-private-subnet-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.28.0/22"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-jmeter-private-subnet-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id                  = aws_vpc.common.id
  cidr_block              = "${var.cidr_prefix}.32.0/22"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-jmeter-private-subnet-1d"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.common.id
  tags = {
    Name = "${var.project}-jmeter-private-rt"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1d" {
  subnet_id      = aws_subnet.private_1d.id
  route_table_id = aws_route_table.private.id
}