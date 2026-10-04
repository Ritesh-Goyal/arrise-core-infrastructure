variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "console_users" {
  type = list(string)

  default = [
    "virat",
    "rohit"
  ]
}

variable "arrise_artifact_bucket" {
  type    = string
  default = "arrise-build-artifacts"
}