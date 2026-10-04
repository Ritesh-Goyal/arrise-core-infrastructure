variable "env" {}

variable "owner" {
  type    = string
  default = "arrise"
}
variable "vpc_cidr" {
  type = string
}
variable "private_subnets" {
  type = any
}
variable "public_subnets" {
  type = any
}

variable "network_acls" {

  type = map(object({
    vpc        = string
    subnet_ids = list(string)
    egress     = list(any)
    ingress    = list(any)
  }))

}

variable "vpc_module_version" {
  type    = string
  default = "v6.6.0"

}