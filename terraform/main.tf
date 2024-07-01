############## DEV ENVIRONMENT ###############
module "environment_dev" {
  source       = "./environment"
  environment  = "dev"
  aws_region   = var.aws_region
  project_name = var.project_name
  ec2_ingress  = var.ec2_ingress_dev
  ec2_settings = var.ec2_settings_dev
  rds_settings = var.rds_settings_dev
  rds_username = var.rds_username_dev
  rds_password = var.rds_password_dev
}
##############################################
