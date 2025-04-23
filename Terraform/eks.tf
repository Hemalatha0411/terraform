module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.36.0"
  cluster_name    = "cmm-poc"
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnet_ids

  enable_irsa = true

  tags = {
    cluster = "demo"
  }

  vpc_id = var.vpc_id


  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
    cluster_upgrade_policy = {
      support_type = "STANDARD"
    }
  }
  cluster_upgrade_policy = {
    support_type = "STANDARD"
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}

