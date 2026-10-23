resource "aws_eks_cluster" "main" {
  name     = "shopflow-${var.environment}-cluster"
  role_arn = var.cluster_role_arn
  version  = "1.30"

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name = "shopflow-${var.environment}-cluster"
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "shopflow-${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  
  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_cluster.main
  ]

  tags = {
    Name = "shopflow-${var.environment}-node-group"
  }
}
