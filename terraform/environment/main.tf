resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "vpc-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "internet-gateway-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "internet-gateway-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = data.aws_availability_zones.availability_zones.names[0]

  tags = {
    Name        = "public-subnet-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "public-subnet-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]

  tags = {
    Name        = "private-subnet-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "private-subnet-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name        = "public-route-table-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "public-route-table-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "private-route-table-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "private-route-table-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = 2
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_security_group" "ec2_security_group" {
  name   = "ec2-security-group-${lower(var.project_name)}-${lower(var.environment)}"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ec2_ingress
    content {
      description = "Allow Access Port ${ingress.value.to}"
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "Allow All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ec2-security-group-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "ec2-security-group-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_security_group" "db_security_group" {
  name   = "db-security-group-${lower(var.project_name)}-${lower(var.environment)}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description     = "Allow EC2"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  tags = {
    Name        = "db-security-group-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "db-security-group-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group-${lower(var.project_name)}-${lower(var.environment)}"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]

  tags = {
    Name        = "db-subnet-group-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "db-subnet-group-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier                = "db-instance-${lower(var.project_name)}-${lower(var.environment)}"
  final_snapshot_identifier = "final-snapshot-${lower(var.project_name)}-${lower(var.environment)}"
  allocated_storage         = var.rds_settings.allocated_storage
  engine                    = var.rds_settings.engine
  engine_version            = var.rds_settings.engine_version
  instance_class            = var.rds_settings.instance_class
  db_name                   = var.rds_settings.db_name
  skip_final_snapshot       = var.rds_settings.skip_final_snapshot
  storage_type              = var.rds_settings.storage_type
  username                  = var.rds_username
  password                  = var.rds_password
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids    = [aws_security_group.db_security_group.id]

  tags = {
    Name        = "db_instance-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "db-instance-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key-pair-${lower(var.project_name)}-${lower(var.environment)}"
  public_key = file("./../key-pair.pub")

  tags = {
    Name        = "key-pair-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "key-pair-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_instance" "instance" {
  ami                    = var.ec2_settings.ami_type
  instance_type          = var.ec2_settings.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name        = "instance-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "instance-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id
  domain   = "vpc"
  
  tags = {
    Name        = "eip-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "eip-${lower(var.project_name)}-${lower(var.environment)}"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-bucket-${lower(var.project_name)}-${lower(var.environment)}"

  tags = {
    Name        = "s3-bucket-${lower(var.project_name)}-${lower(var.environment)}"
    ManagedBy   = "Terraform"
    ProjectName = var.project_name
    Environment = upper(var.environment)
  }

  tags_all = {
    Name = "s3-bucket-${lower(var.project_name)}-${lower(var.environment)}"
  }
}
