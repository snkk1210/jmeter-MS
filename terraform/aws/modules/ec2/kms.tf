/** 
# KMS
*/
data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}