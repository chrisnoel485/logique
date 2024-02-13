module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "logique"
  cluster_version = "1.29"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false #set to false and create vpn server to access private. its only testing acces without vpn server
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 100
  }

  eks_managed_node_groups = {
    node_group_v1 = {
      desired_size = 4
      min_size     = 4
      max_size     = 10

      labels = {
        role = "node_group_v1"
      }

      instance_types = ["c6a.large"]
      force_update_version = false
      update_config = {
        max_unavailable_percentage = 50
      }
      capacity_type  = "ON_DEMAND"

      create_iam_role          = true
      iam_role_name            = "logique-node_group_v1"
      iam_role_use_name_prefix = false
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
    }
  }
  
  tags = {
    Environment = "logique"
  }
}