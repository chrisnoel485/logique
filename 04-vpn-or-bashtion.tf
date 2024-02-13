module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "logique"
  create_private_key = true
}

module "security_group_vpn" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "logique-sg"
  description = "Logique security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow https"
      cidr_blocks = "0.0.0.0/0"
    }, 
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "allow from my ip"
      cidr_blocks = "119.2.44.46/32"
    },
  ]
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "logique-vpn"

  instance_type          = "t2.small"
  key_name               = "logique"
  monitoring             = true
  vpc_security_group_ids = [module.security_group_vpn.security_group_id]
  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Environment = "logique"
  }
}