variable "ami" {
  description = "AMI used in instance"
  default = ""
}
variable "instance_type" {
    description = "type of instance used"
    type = map(string)
    default = {
      "dev" = "t2.micro"
      "test" = "t2.small"
      "prod" = "t2.medium"
    }
  
}