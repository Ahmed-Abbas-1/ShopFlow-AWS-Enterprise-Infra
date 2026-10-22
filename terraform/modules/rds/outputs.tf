output "db_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.mysql.address
}

output "db_secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds.id
}
