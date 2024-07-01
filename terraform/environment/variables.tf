variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR Block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "Private Subnet CIDR Block"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "ec2_ingress" {
  description = "EC2 Ingress Rules"
  type = list(object({
    from        = number
    to          = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "ec2_settings" {
  description = "EC2 Settings"
  type        = map(string)
}

variable "rds_settings" {
  description = "RDS Settings"
  type        = map(string)
}

variable "rds_username" {
  description = "Database Root User"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "Database Root Password"
  type        = string
  sensitive   = true
}
