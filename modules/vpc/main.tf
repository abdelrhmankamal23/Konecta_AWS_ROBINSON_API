resource "aws_vpc" "vpc_eu-west-1" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.tags
}

resource "aws_subnet" "Public1-eu-west-1a" {
  vpc_id            = aws_vpc.vpc_eu-west-1.id
  cidr_block        = "10.133.63.96/28"
  availability_zone = "eu-west-1a"
  tags = {
    Platform = "Terraform"
    Project  = "Robinson API"
    Name     = "10.133.63.96/28-Public1-eu-west-1a"
    Country  = "Espana"
  }
}

resource "aws_subnet" "Private1-eu-west-1a" {
  vpc_id            = aws_vpc.vpc_eu-west-1.id
  cidr_block        = "10.133.63.64/28"
  availability_zone = "eu-west-1a"
  tags = {
    Name     = "10.133.63.64/28-Private1-eu-west-1a"
    Platform = "Terraform"
    Country  = "Espana"
    Project  = "Robinson API"
  }
}

resource "aws_subnet" "Public2-eu-west-1b" {
  vpc_id            = aws_vpc.vpc_eu-west-1.id
  cidr_block        = "10.133.63.112/28"
  availability_zone = "eu-west-1b"
  tags = {
    Country  = "Espana"
    Platform = "Terraform"
    Name     = "10.133.63.112/28-Public2-eu-west-1b"
    Project  = "Robinson API"
  }
}

resource "aws_subnet" "Private2-eu-west-1b" {
  vpc_id            = aws_vpc.vpc_eu-west-1.id
  cidr_block        = "10.133.63.80/28"
  availability_zone = "eu-west-1b"
  tags = {
    Project  = "Robinson API"
    Name     = "10.133.63.80/28-Private2-eu-west-1b"
    Country  = "Espana"
    Platform = "Terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_eu-west-1.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "IGW-Robinson API"
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat1" {
  domain = "vpc"
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "EIP-Robinson API-1"
  }
}

resource "aws_eip" "nat2" {
  domain = "vpc"
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "EIP-Robinson API-2"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.Public1-eu-west-1a.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "NAT-Robinson API-1"
  }
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.Public2-eu-west-1b.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "NAT-Robinson API-2"
  }
}

# Route Tables
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.vpc_eu-west-1.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "RT-Public1"
  }
}

resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.vpc_eu-west-1.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "RT-Public2"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.vpc_eu-west-1.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "RT-Private1"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.vpc_eu-west-1.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "RT-Private2"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.Public1-eu-west-1a.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.Public2-eu-west-1b.id
  route_table_id = aws_route_table.public2.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.Private1-eu-west-1a.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.Private2-eu-west-1b.id
  route_table_id = aws_route_table.private2.id
}

# Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = [aws_subnet.Private1-eu-west-1a.id, aws_subnet.Private2-eu-west-1b.id]
  transit_gateway_id = "tgw-0f6739e2525074a0a"
  vpc_id             = aws_vpc.vpc_eu-west-1.id
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "TGW-Attach-Irlanda-core"
  }
}

# Default Network ACL
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc_eu-west-1.default_network_acl_id
  
  subnet_ids = [
    aws_subnet.Private1-eu-west-1a.id,
    aws_subnet.Public2-eu-west-1b.id,
    aws_subnet.Public1-eu-west-1a.id,
    aws_subnet.Private2-eu-west-1b.id
  ]
  
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }
  
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_code  = 0
    icmp_type  = 0
  }
  
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "ACL-Robinson API-Default"
  }
}

# Default Security Group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc_eu-west-1.id
  
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["10.133.63.64/26"]
  }
  
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Project  = "Robinson API"
    Platform = "Terraform"
    Country  = "Espana"
    Name     = "SG-Robinson API-Default"
  }
}