/** 
# Variables for COMMON
*/
variable "project" {
  type    = string
  default = "snkk1210"
}

variable "environment" {
  type    = string
  default = "loadtest"
}

/** 
# Variables for EC2
*/
variable "c_number" {
  type        = number
  default     = 1
  description = "Number of Controller"
}

variable "w_number" {
  type        = number
  default     = 2
  description = "Number of Worker"
}

variable "enable_c_provision" {
  type        = bool
  default     = true
  description = "Whether to provision Controller or not"
}

variable "enable_w_provision" {
  type        = bool
  default     = true
  description = "Whether to provision Worker or not"
}

variable "security_group_rules_controller" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Controller Server Connection IP"
}

variable "security_group_rules_worker" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Worker Server Connection IP"
}

variable "ami" {
  type        = string
  default     = "ami-0b299c22ffb336d85"
  description = "default: Almalinux8"
}

variable "instance_type" {
  type        = string
  default     = "m5.large"
  description = "m5.large or larger recommended"
}

variable "volume_size" {
  type    = number
  default = 30
}