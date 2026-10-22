variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM Role ARN for the EKS Node Group"
  type        = string
}
