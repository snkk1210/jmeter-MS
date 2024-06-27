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

/** 
# Variables for EC2
*/
variable "vpc_cidr" {
  type = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  default = []
}

variable "ami" {
  type        = string
  description = "AMI ID to launch"
  default     = "ami-0b299c22ffb336d85"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch"
  default     = "t3.micro"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to grant public IP"
  default     = true
}

variable "root_block_device" {
  type = object({
    volume_type           = string
    volume_size           = number
    delete_on_termination = bool
    encrypted             = bool
  })
  description = "Setting the root volume associated with the instance"
  default = {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = false
  }
}

variable "security_group_rules_controller" {
  type    = list(string)
  default = []
}

variable "security_group_rules_worker" {
  type    = list(string)
  default = []
}

variable "c_number" {
  type    = number
  default = "1"
}

variable "w_number" {
  type    = number
  default = "1"
}

variable "enable_c_provision" {
  type    = bool
  default = false
}

variable "enable_w_provision" {
  type    = bool
  default = false
}
