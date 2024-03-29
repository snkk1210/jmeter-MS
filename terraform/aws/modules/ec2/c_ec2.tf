/**
# NOTE: Controller KMS
*/
resource "aws_kms_key" "controller_storage" {
  description             = "${var.project}-jmeter-controller-storage-kms"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
}

resource "aws_kms_alias" "controller_storage" {
  name          = "alias/${var.project}/jmeter/controller_storage_kms_key"
  target_key_id = aws_kms_key.controller_storage.id
}

/**
# NOTE: Controller
*/
resource "aws_instance" "controller" {
  count                       = var.c_number
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.controller.id]
  key_name                    = aws_key_pair.key_pair.id
  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = var.associate_public_ip_address
  //iam_instance_profile        = aws_iam_instance_profile.controller_profile.name

  root_block_device {
    volume_type           = var.root_block_device.volume_type
    volume_size           = var.root_block_device.volume_size
    delete_on_termination = var.root_block_device.delete_on_termination
    encrypted             = var.root_block_device.encrypted
    kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.controller_storage.key_id : null
  }

  tags = {
    Name = "${var.project}-jmeter-${format("controller%02d", count.index + 1)}"
  }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
      root_block_device,
    ]
  }

}

resource "aws_eip" "controller" {
  count    = var.c_number
  instance = element(aws_instance.controller.*.id, count.index)
  vpc      = true

  tags = {
    Name = "${var.project}-jmeter-${format("controller%02d", count.index + 1)}-eip"
  }
}