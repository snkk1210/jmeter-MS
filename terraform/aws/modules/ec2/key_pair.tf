resource "aws_key_pair" "this" {
  key_name   = "${var.common.project}-${var.common.environment}-jmeter-secret-key"
  public_key = file("${path.module}/key/jmeter.key.pub")
}