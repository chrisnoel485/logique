module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "logique-sg"
  description = "Logique security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = {
    Environment = "logique"
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "logique"

  engine            = "postgres"
  engine_version    = "14"
  instance_class    = "db.m6i.large"
  allocated_storage     = 100
  max_allocated_storage = 200

  db_name  = "logique"
  username = "logique"
  port     = 5432

  multi_az  = true
  create_db_subnet_group = true
  subnet_ids  = module.vpc.private_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window   = "03:00-06:00"

  performance_insights_enabled  = true
  performance_insights_retention_period = 7
  monitoring_interval = 60
  monitoring_role_name  = "LogiqueRDSMonitoringRole"
  create_monitoring_role  = true

  family = "postgres14"
  tags = {
    Owner       = "logique"
    Environment = "logique"
  }
  backup_retention_period = 7
  skip_final_snapshot = false
  deletion_protection = true
}