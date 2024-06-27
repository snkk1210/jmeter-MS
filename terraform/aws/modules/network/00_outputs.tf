output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "public_subnet_ids" {
  value = tolist(
    [
      aws_subnet.public_1a.id,
      aws_subnet.public_1c.id,
    ]
  )
}

output "isolated_subnet_ids" {
  value = tolist(
    [
      aws_subnet.isolated_1a.id,
      aws_subnet.isolated_1c.id,
    ]
  )
}