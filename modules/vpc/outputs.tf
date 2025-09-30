output "vpc_id" {
  value = aws_vpc.vpc_eu-west-1.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc_eu-west-1.cidr_block
}

output "public1_subnet_id" {
  value = aws_subnet.Public1-eu-west-1a.id
}

output "private1_subnet_id" {
  value = aws_subnet.Private1-eu-west-1a.id
}

output "public2_subnet_id" {
  value = aws_subnet.Public2-eu-west-1b.id
}

output "private2_subnet_id" {
  value = aws_subnet.Private2-eu-west-1b.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_1_id" {
  value = aws_nat_gateway.nat1.id
}

output "nat_gateway_2_id" {
  value = aws_nat_gateway.nat2.id
}

output "security_group_default_id" {
  value = aws_default_security_group.default.id
}