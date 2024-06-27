/**
# Controller
*/
resource "aws_instance" "controller" {
  count                       = var.c_number
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.controller.id]
  key_name                    = aws_key_pair.key_pair.id
  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.ebs.key_id : null
  }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      root_block_device,
    ]
  }

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-jmeter-${format("controller%02d", count.index + 1)}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}

resource "aws_eip" "controller" {
  count    = var.c_number
  instance = element(aws_instance.controller.*.id, count.index)
  domain   = "vpc"

  tags = {
    Name        = "${var.common.project}-${var.common.environment}-jmeter-${format("controller%02d", count.index + 1)}-eip"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}