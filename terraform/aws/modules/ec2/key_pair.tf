resource "aws_key_pair" "key_pair" {
  key_name   = "${var.project}-jmeter-secret-key"
  public_key = file("${path.module}/public_key/jmeter.pub")
}