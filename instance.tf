module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"
 
  ami                    = "ami-0e4d9ed95865f3b40"
  instance_type          = "t2.micro"
  key_name               = "new-key"
  monitoring             = true
  vpc_security_group_ids = try(resource.aws_security_group.dynamicsg.*.id,"")
  subnet_id              = try(module.vpc.public_subnets[0] ,"")
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
 user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl enable nginx
sudo systemctl start nginx
              EOF
}