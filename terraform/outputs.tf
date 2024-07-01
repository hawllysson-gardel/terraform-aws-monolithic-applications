output "dev_ec2_public_ip" {
  description = "DEV EC2 Public IP"
  value       = module.environment_dev.ec2_public_ip
  depends_on  = [module.environment_dev]
}

output "dev_ec2_public_dns" {
  description = "DEV EC2 Public DNS"
  value       = module.environment_dev.ec2_public_dns
  depends_on  = [module.environment_dev]
}

output "dev_rds_endpoint" {
  description = "DEV RDS Endpoint"
  value       = module.environment_dev.rds_endpoint
  depends_on  = [module.environment_dev]
}

output "dev_rds_port" {
  description = "DEV RDS Port"
  value       = module.environment_dev.rds_port
  depends_on  = [module.environment_dev]
}
