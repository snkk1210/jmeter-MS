resource "aws_security_group" "controller" {
  name        = "${var.project}-jmeter-controller-sg"
  description = "Security group for Controller"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.project}-jmeter-controller-sg"
  }
}

resource "aws_security_group_rule" "controller_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.controller.id
}

resource "aws_security_group_rule" "controller_external_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.security_group_rules_controller
  security_group_id = aws_security_group.controller.id

  lifecycle {
    ignore_changes = [
      cidr_blocks
    ]
  }
}

resource "aws_security_group_rule" "controller_internal_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.cidr_prefix}.0.0/16"]
  security_group_id = aws_security_group.controller.id

  lifecycle {
    ignore_changes = [
      cidr_blocks
    ]
  }
}