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
  
locals {
   ingress_rules = [{
      port        = 443
      description = "Ingress rules for port 443"
   },
   {
      port        = 80
      description = "Ingree rules for port 80"
   }]
}

resource "aws_security_group" "main" {
   name   = "resource_with_dynamic_block"
   vpc_id = module.vpc.vpc_id

   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }

   tags = {
      Name = "AWS security group dynamic block"
   }
}
locals {
   egress_rules = [{
      port        = 0
   }]
}

resource "aws_security_group" "main2" {
   name   = "resource_with_dynamic_block"
   vpc_id = module.vpc.vpc_id

   dynamic "egress" {
      for_each = local.egress_rules

      content {
         from_port   = egress.value.port
         to_port     = egress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }

   tags = {
      Name = "AWS security group dynamic block egress"
   }
}
