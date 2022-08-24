 provider "aws" {
    region = "us-west-1"
    profile = "xyz"
 } 


 locals {
  name   = "trail"
  region = "us-west-1"
  Environment = "dev"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = local.name
  cidr = var.cidr
 azs                 = ["${local.region}a", "${local.region}c"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24"]

  
  enable_nat_gateway = true
  single_nat_gateway  = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = true
}
variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80,443]
}

resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
