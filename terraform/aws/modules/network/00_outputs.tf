output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "public_subnet_ids" {
  value = tolist(
    [
      aws_subnet.public_az1.id,
      aws_subnet.public_az2.id,
    ]
  )
}

output "isolated_subnet_ids" {
  value = tolist(
    [
      aws_subnet.isolated_az1.id,
      aws_subnet.isolated_az2.id,
    ]
  )
}