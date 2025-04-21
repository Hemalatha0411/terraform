module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "vpc-module-demo"
  cidr = "10.242.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 1)
  private_subnets = ["10.242.1.0/24", "10.242.2.0/24"]
  public_subnets  = ["10.242.3.0/24", "10.242.4.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Name = "${var.cluster-name}-vpc"
  }
}
