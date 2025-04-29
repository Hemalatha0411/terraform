resource "aws_security_group" "eks_nodes" {
  name        = var.eks-nodes-sg
  description = "Security group for EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

---------------

resource "aws_security_group_rule" "allow_tcp_from_pods_to_eks_cluster" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.244.41.0/24"]
  security_group_id = module.eks.cluster_security_group_id
  description       = "Allow all TCP from pod CIDR to EKS cluster"
}
