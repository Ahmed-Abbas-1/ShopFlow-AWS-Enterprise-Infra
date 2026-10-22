# 1. Generate a secure random password
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# 2. Create a Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "shopflow-${var.environment}-rds-sg"
  description = "Allow MySQL traffic from VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "shopflow-${var.environment}-rds-sg"
  }
}

# 3. Create DB Subnet Group (places the DB in private subnets)
resource "aws_db_subnet_group" "main" {
  name       = "shopflow-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "shopflow-${var.environment}-db-subnet-group"
  }
}

# 4. Create the RDS Instance
resource "aws_db_instance" "mysql" {
  identifier             = "shopflow-${var.environment}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "shopflowdb"
  username               = "admin"
  password               = random_password.db_password.result
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true
  skip_final_snapshot    = true # Set to true for dev to allow easy deletion

  tags = {
    Name = "shopflow-${var.environment}-mysql"
  }
}

# 5. Store Credentials in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "shopflow-${var.environment}-db-creds"
  recovery_window_in_days = 0 
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = aws_db_instance.mysql.username
    password = random_password.db_password.result
    engine   = aws_db_instance.mysql.engine
    host     = aws_db_instance.mysql.address
    port     = aws_db_instance.mysql.port
    dbname   = aws_db_instance.mysql.db_name
  })
}
