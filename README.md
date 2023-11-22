Terraform AWS Locust 

This project uses Terraform to provision AWS resources for a Locust load testing setup. It includes the creation of VPC, subnets, security groups, IAM roles, and EC2 instances for running Locust in master-worker mode.
Prerequisites

- Terraform v0.12 or later
- AWS account with necessary permissions
- AWS CLI configured with access key and secret
Configuration

Create a terraform.tfvars file in the root directory of the project. This file will contain the necessary variables for the Terraform configuration. Here's an example of what this file might look like:

```
aws_region = "us-east-1"
aws_ami = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 us-east-1
vpc_name = "vpc-locust-terraform"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
public_subnet_bckp_cidr = "10.0.2.0/24"
private_subnet_cidr = "10.0.3.0/24"
master_instance_type = "t2.micro"
workers_instance_type = "t3.small"
key_name = "my-key-pair"
workers_count = 3
```

Please replace the values with your own. The key_name should be the name of an existing EC2 Key Pair in your AWS account.
Running the Project

1. Initialize Terraform:
terraform init

2. Plan the deployment:
terraform plan

3. Apply the configuration:
terraform apply

After running terraform apply, Terraform will output the load balancer dns. You can use this to access the Locust web interface.

**Allow up to 5 minutes to instances run scripts after terraform apply is complete. After this you should can access via ALB dns.**

1. Cleaning Up

To destroy the resources created by this project, run:
terraform destroy

This will remove all resources created by Terraform in this project.