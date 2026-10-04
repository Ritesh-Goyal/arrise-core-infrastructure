# Arrise EC2 Instance Terraform Module

This Terraform module creates and manages AWS EC2 instances with configurable options.

## Usage

```hcl
module "ec2_instance" {
    source  = "../modules/terraform-aws-compute//ec2-instance"
    name    = "example-instance"
    ami     = "ami-xxxxxxxx"
    instance_type = "t3.micro"

    # Optional variables
    subnet_id            = "subnet-xxxxxxx"
    vpc_security_group_ids = ["sg-xxxxxxx"]
    key_name             = "my-key"
    tags = {
        Environment = "dev"
    }
}
```

## Inputs

| Name                   | Description                        | Type     | Default     | Required |
|------------------------|------------------------------------|----------|-------------|----------|
| name                   | Name for the EC2 instance          | string   | n/a         | yes      |
| ami                    | AMI ID to use                      | string   | n/a         | yes      |
| instance_type          | EC2 instance type                  | string   | n/a         | yes      |
| subnet_id              | Subnet ID                          | string   | null        | no       |
| vpc_security_group_ids | List of security group IDs          | list     | []          | no       |
| key_name               | Key pair name                      | string   | null        | no       |
| tags                   | Tags to apply                      | map      | {}          | no       |

## Outputs

| Name           | Description                  |
|----------------|-----------------------------|
| id             | EC2 instance ID             |
| public_ip      | Public IP address           |
| private_ip     | Private IP address          |
| arn            | EC2 instance ARN            |
