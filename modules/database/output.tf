output "rds_endpoint" {
  value       = aws_db_instance.rds.endpoint
  description = "RDS endpoint"
  sensitive   = true
}

output "rds_id" {
  value = aws_db_instance.rds.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}