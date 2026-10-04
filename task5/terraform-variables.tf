variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}
