/** 
# Variables for COMMON
*/
variable "common" {
  type = object({
    project     = string
    environment = string
  })

  default = {
    project     = ""
    environment = ""
  }
}

variable "sfx" {
  type    = string
  default = "01"
}

/** 
# Availability zone
*/
variable "az1" {
  type    = string
  default = "ap-northeast-1a"
}

variable "az2" {
  type    = string
  default = "ap-northeast-1c"
}

/** 
# Variables for VPC
*/
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

/** 
# Variables for Subnet ( Public )
*/
variable "public_az1_cidr" {
  type    = string
  default = "10.0.0.0/20"
}

variable "public_az2_cidr" {
  type    = string
  default =  "10.0.16.0/20"
}

/** 
# Variables for Subnet ( Isolated )
*/
variable "isolated_az1_cidr" {
  type    = string
  default = "10.0.32.0/20"
}

variable "isolated_az2_cidr" {
  type    = string
  default = "10.0.48.0/20"
}