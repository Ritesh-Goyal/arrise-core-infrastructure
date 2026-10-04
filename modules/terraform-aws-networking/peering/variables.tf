variable "env" {}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "peer_vpc_id" {
  type = string
}

variable "peer_owner_id" {
  type    = string
  default = ""
}

variable "requestor_vpc_id" {
  type    = string
  default = ""
}

variable "route_table_id_requester" {
  type = list(any)
}

variable "peer_cidr_block" {
  type = string
}

variable "route_table_id_accepter" {
  type = list(any)
}

variable "destination_cidr_block_accepter" {
  type = string
}

variable "role_arn" {
  type    = string
  default = ""
}
