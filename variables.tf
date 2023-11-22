variable "aws_region" {
  default = "us-east-1"
}

variable "aws_ami" {
  default = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 us-east-1
}

variable "vpc_name" {
  default = "vpc-locust-terraform"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
}

variable "public_subnet_bckp_cidr" {
  description = "The CIDR block for the public subnet backup."
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet."
}

variable "master_instance_type" {
  description = "The type of instance to start master of locust."
  default     = "t2.micro"
}

variable "workers_instance_type" {
  description = "The type of instance to start workers of locust."
  default     = "t3.small"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access to the instance."
}

variable "workers_count" {
  description = "the number of workers."
  default     = 2
}