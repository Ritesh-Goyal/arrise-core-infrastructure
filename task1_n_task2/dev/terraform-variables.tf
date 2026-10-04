variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "ssh_key_pair" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEqKmfeNJNM7PLHDK+6VmtB21VMz3vCAnrDtS45Y+7l"
}

variable "ssh_allowed_ips" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type    = string
  default = "10.11.0.0/16"
}

variable "private_subnets" {
  type    = any
  default = ["10.11.0.0/20", "10.11.16.0/20", "10.11.32.0/20"]
  // future private subnets : "10.11.48.0/20", "10.11.64.0/20", "10.11.80.0/20"
  // Private subnet range will be 10.11.0.0 - 10.11.95.254

}

variable "public_subnets" {
  type    = any
  default = ["10.11.240.0/24", "10.11.241.0/24", "10.11.242.0/24"]
  // future public subnets: "10.11.240.0/24", "10.11.241.0/24", "10.11.242.0/24"
  // Public subnet range will be 10.11.240.0 - 10.11.242.254
}

variable "ami" {
  type    = string
  default = "ami-0f8a61b66d1accaee" // Ubuntu  24.04 LTS (HVM), SSD Volume Type
}

variable "configuration" {
  description = "The total configuration, List of Objects/Dictionary"
  default     = [{}]
}


variable "dev_names" {
  type    = list(string)
  default = ["doug", "trevor", "ritesh"]
}
