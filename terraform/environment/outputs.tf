output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_eip.eip.public_ip
  depends_on  = [aws_eip.eip]
}

output "ec2_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_eip.eip.public_dns
  depends_on  = [aws_eip.eip]
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.db_instance.address
}

output "rds_port" {
  description = "RDS Port"
  value       = aws_db_instance.db_instance.port
}
