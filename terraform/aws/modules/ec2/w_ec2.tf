/**
# Worker
*/
resource "aws_instance" "worker" {
  count                       = var.w_number
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.worker.id]
  key_name                    = aws_key_pair.this.id
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
    Name        = "${var.common.project}-${var.common.environment}-jmeter-${format("worker%02d", count.index + 1)}"
    Environment = var.common.environment
    Createdby   = "Terraform"
  }
}