resource "aws_key_pair" "key_pair" {
  key_name   = "${var.common.project}-${var.common.environment}-jmeter-secret-key"
  public_key = file("${path.module}/public_key/jmeter.pub")
}