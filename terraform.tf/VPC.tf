module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = "react-app-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false
  enable_dns_hostnames = true
  tags = {
    Name = "react-app-vpc"
  }
}