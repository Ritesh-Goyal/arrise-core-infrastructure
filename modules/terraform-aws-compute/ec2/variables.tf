variable "env" {}

variable "vpc" {
  type    = any
  default = {}
}

variable "ssh_key_pair" {
  type    = any
  default = {}
}

variable "sg_pub_id" {
  type    = any
  default = {}
}

variable "sg_priv_id" {
  type    = any
  default = {}
}

variable "dev_instance_type" {
  type    = string
  default = null
}

variable "volume_size" {
  type    = any
  default = 30
}

variable "dev_name" {
  type    = string
  default = "ritesh"
}

variable "configuration" {
  description = "The total configuration, List of Objects/Dictionary"
  default     = [{}]
}

variable "create_key_pair" {
  description = "Whether to create the AWS key pair"
  type        = bool
  default     = true
}