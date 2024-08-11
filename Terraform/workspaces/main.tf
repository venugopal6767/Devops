provider "aws" {
    region = "us-east-1" 
}

module "ec2" {
  source = "./modules/ec2"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}