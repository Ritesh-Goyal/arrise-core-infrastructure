# Glimmer terraform-aws-compute
This repository provides reusable Terraform modules for managing AWS compute resources. The following modules are included:

- **[ALB](./modules/alb/README.md)**: Application Load Balancer  
    - **Resources Created:**  
      - `aws_lb`: Application Load Balancer  
      - `aws_lb_target_group`: Target groups for routing  
      - `aws_lb_listener`: Listeners for HTTP/HTTPS  
      - `aws_lb_listener_rule`: Listener rules for advanced routing  
    - **Features:**  
      - Supports HTTP/HTTPS  
      - Configurable health checks  
      - Integration with target groups and security groups  
      - Listener rules for path-based or host-based routing  

- **[autoscaling](./modules/autoscaling/README.md)**: Auto Scaling Groups  
    - **Resources Created:**  
      - `aws_autoscaling_group`: Auto Scaling Group  
      - `aws_launch_template` or `aws_launch_configuration`: Instance launch definitions  
      - `aws_autoscaling_policy`: Scaling policies  
      - `aws_autoscaling_lifecycle_hook`: Lifecycle hooks  
    - **Features:**  
      - Dynamic and scheduled scaling  
      - Integration with ALB/NLB target groups  
      - Customizable health checks and notifications  
      - Supports mixed instance policies  

- **[ec2-instance](./modules/ec2-instance/README.md)**: EC2 Instances  
    - **Resources Created:**  
      - `aws_instance`: EC2 instance  
      - `aws_security_group`: Security groups  
      - `aws_iam_role` and `aws_iam_instance_profile`: IAM roles for EC2  
      - `aws_ebs_volume` and `aws_volume_attachment`: EBS volumes  
    - **Features:**  
      - Custom AMI, instance type, and user data  
      - Optional EBS volume attachments  
      - SSH key and IAM role management  
      - Tagging and monitoring support  

- **[elastictranscoder](./modules/elastictranscoder/README.md)**: AWS Elastic Transcoder  
    - **Resources Created:**  
      - `aws_elastictranscoder_pipeline`: Transcoder pipeline  
      - `aws_elastictranscoder_preset`: Encoding presets  
      - `aws_iam_role`: IAM roles for pipeline access  
    - **Features:**  
      - Pipeline setup for media transcoding  
      - Custom and system presets  
      - S3 input/output integration  
      - IAM permissions for secure operation  

- **[ec2](./modules/ec2/README.md)**: (Deprecated) Legacy EC2 resource management  
    - **Resources Created:**  
      - Legacy EC2 instance and related resources  
    - **Notes:**  
      - No longer maintained; use `ec2-instance` for new deployments  
      - Limited feature set compared to `ec2-instance`  

---

## Usage

Each module can be used by referencing its source path in your Terraform configuration. Example usage:

```hcl
module "alb" {
    source = "./modules/alb"
    # ...module variables
}

module "autoscaling" {
    source = "./modules/autoscaling"
    # ...module variables
}

module "ec2_instance" {
    source = "./modules/ec2-instance"
    # ...module variables
}

module "elastictranscoder" {
    source = "./modules/elastictranscoder"
    # ...module variables
}
```

Refer to each module's README for detailed documentation, input/output variables, and examples:

- [ALB Module](./modules/alb/README.md)
- [Autoscaling Module](./modules/autoscaling/README.md)
- [EC2 Instance Module](./modules/ec2-instance/README.md)
- [Elastic Transcoder Module](./modules/elastictranscoder/README.md)
- [EC2 (Deprecated) Module](./modules/ec2/README.md)

---

