resource "aws_ecr_repository" "app_repo" {
  name                 = "shopflow-${var.environment}-app"
  image_tag_mutability = "MUTABLE"

  # (Security Best Practice)
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "shopflow-${var.environment}-app"
  }
}
