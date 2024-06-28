resource "aws_security_group" "worker" {
  name        = "${var.common.project}-${var.common.environment}-jmeter-worker-sg"
  description = "Security group for worker"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.common.project}-${var.common.environment}-jmeter-worker-sg"
  }
}

resource "aws_security_group_rule" "worker_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker.id
}

resource "aws_security_group_rule" "worker_external_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.security_group_rules_worker
  security_group_id = aws_security_group.worker.id

  lifecycle {
    ignore_changes = [
      cidr_blocks
    ]
  }
}

resource "aws_security_group_rule" "worker_internal_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.worker.id

  lifecycle {
    ignore_changes = [
      cidr_blocks
    ]
  }
}