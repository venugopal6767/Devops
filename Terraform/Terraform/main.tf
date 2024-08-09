provider "aws" {
    region = "us-east-1" 
}

module "ec2" {
  source = "./modules/ec2"
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
}