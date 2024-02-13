module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "logique"
  cidr = "192.168.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"] #["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19"]
  public_subnets  = ["192.168.96.0/19", "192.168.128.0/19", "192.168.160.0/19"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "logique"
  }
}
