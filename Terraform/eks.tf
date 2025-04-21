module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.35.0"

  cluster_name    = "cmm-poc-eks"
  cluster_version = "1.32"
  subnet_ids      = ["subnet-0c09df98ebc8819fa"]
  vpc_id          = "vpc-063273428bad6e1f0"

  enable_irsa                      = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  cluster_enabled_log_types       = ["api", "scheduler", "controllerManager"]

  eks_managed_node_groups = {
    frontend = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      subnet_ids     =["subnet-0c09df98ebc8819fa"]
      ami_type       = "AL2_x86_64"
    }

  }

  tags = {
    Environment = "dev"
    Terraform     = "True"
  }
}

