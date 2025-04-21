variable "kubernetes_version" {
  default     = 1.32
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.242.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "us-east-1"
  description = "aws region"
}
variable "bucket_name" {
  type        = string
  description = "Test bucket"
  default     = "cmm-poc-dev"
}
