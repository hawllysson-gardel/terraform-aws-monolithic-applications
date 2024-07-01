############### ENVIRONMENT #################
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "MyProject"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "sa-east-1"
}

############## DEV ENVIRONMENT ###############
variable "ec2_ingress_dev" {
  description = "EC2 Ingress Rules"
  type = list(object({
    from        = number
    to          = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from        = 22
      to          = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from        = 80
      to          = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ec2_settings_dev" {
  description = "EC2 Settings"
  type        = map(string)
  default = {
    instance_type = "t3.micro"
    ami_type      = "ami-04716897be83e3f04"
  }
}

variable "rds_settings_dev" {
  description = "RDS Settings"
  type        = map(string)
  default = {
    allocated_storage   = 20
    storage_type        = "gp2"
    engine              = "mysql"
    engine_version      = "8.0.37"
    instance_class      = "db.t3.micro"
    db_name             = "mydb"
    skip_final_snapshot = false
  }
}

variable "rds_username_dev" {
  description = "Database Root User"
  type        = string
  sensitive   = true
}

variable "rds_password_dev" {
  description = "Database Root Password"
  type        = string
  sensitive   = true
}


############## STG ENVIRONMENT ###############
variable "ec2_ingress_stg" {
  description = "EC2 Ingress Rules"
  type = list(object({
    from        = number
    to          = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from        = 22
      to          = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from        = 80
      to          = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ec2_settings_stg" {
  description = "EC2 Settings"
  type        = map(string)
  default = {
    instance_type = "t3.micro"
    ami_type      = "ami-04716897be83e3f04"
  }
}

variable "rds_settings_stg" {
  description = "RDS Settings"
  type        = map(string)
  default = {
    allocated_storage   = 20
    storage_type        = "gp2"
    engine              = "mysql"
    engine_version      = "8.0.37"
    instance_class      = "db.t3.micro"
    db_name             = "mydb"
    skip_final_snapshot = false
  }
}

variable "rds_username_stg" {
  description = "Database Root User"
  type        = string
  sensitive   = true
}

variable "rds_password_stg" {
  description = "Database Root Password"
  type        = string
  sensitive   = true
}


############## PRD ENVIRONMENT ###############
variable "ec2_ingress_prd" {
  description = "EC2 Ingress Rules"
  type = list(object({
    from        = number
    to          = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from        = 22
      to          = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from        = 80
      to          = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ec2_settings_prd" {
  description = "EC2 Settings"
  type        = map(string)
  default = {
    instance_type = "t3.micro"
    ami_type      = "ami-04716897be83e3f04"
  }
}

variable "rds_settings_prd" {
  description = "RDS Settings"
  type        = map(string)
  default = {
    allocated_storage   = 20
    storage_type        = "gp2"
    engine              = "mysql"
    engine_version      = "8.0.37"
    instance_class      = "db.t3.micro"
    db_name             = "mydb"
    skip_final_snapshot = false
  }
}

variable "rds_username_prd" {
  description = "Database Root User"
  type        = string
  sensitive   = true
}

variable "rds_password_prd" {
  description = "Database Root Password"
  type        = string
  sensitive   = true
}
