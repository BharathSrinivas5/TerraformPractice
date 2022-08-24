module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-0e4d9ed95865f3b40"
  instance_type          = "t2.micro"
  key_name               = "new-key"
  monitoring             = true
  subnet_id              = try(module.vpc.aws_subnet.public[*], "")  

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}