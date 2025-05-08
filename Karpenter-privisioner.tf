resource "kubernetes_manifest" "karpenter_provisioner" {
  manifest = {
    apiVersion = "karpenter.sh/v1alpha5"
    kind       = "Provisioner"
    metadata = {
      name = "default"
    }
    spec = {
      requirements = [
        {
          key      = "karpenter.sh/capacity-type"
          operator = "In"
          values   = ["on-demand"]
        },
        {
          key      = "node.kubernetes.io/instance-type"
          operator = "In"
          values   = ["t3.large", "m4.xlarge", "g4dn.xlarge"]
        }
      ]
      limits = {
        resources = {
          cpu = "1000"
        }
      }
      provider = {
        subnetSelector = {
          "karpenter.sh/discovery" = var.cluster_name
        }
        securityGroupSelector = {
          "karpenter.sh/discovery" = var.cluster_name
        }
        tags = {
          "Name" = "karpenter-node"
        }
      }
      ttlSecondsAfterEmpty = 60
    }
  }
}
