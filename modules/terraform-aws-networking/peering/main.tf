locals {
  owner       = "arrise"
  module_name = "${var.env}-${local.owner}"
}

provider "aws" {
  alias  = "peer-account"
  region = var.region
  assume_role {
    role_arn     = var.role_arn
    session_name = "terraform-acceptor-user"
    external_id  = "terraform_acceptor-id"
  }
}

data "aws_vpc_peering_connection" "arrise_vpc_peering" {
  vpc_id          = var.requestor_vpc_id
  peer_vpc_id     = var.peer_vpc_id
  peer_owner_id   = var.peer_owner_id
  peer_cidr_block = var.peer_cidr_block
}

resource "aws_route" "vpc_peering_route_requester" {
  count                     = length(var.route_table_id_requester)
  route_table_id            = element(var.route_table_id_requester, count.index)
  destination_cidr_block    = data.aws_vpc_peering_connection.arrise_vpc_peering.peer_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.arrise_vpc_peering.id
}

resource "aws_route" "vpc_peering_route_accepter" {
  provider                  = aws.peer-account
  count                     = length(var.route_table_id_accepter)
  route_table_id            = element(var.route_table_id_accepter, count.index)
  destination_cidr_block    = var.destination_cidr_block_accepter
  vpc_peering_connection_id = data.aws_vpc_peering_connection.arrise_vpc_peering.id
}