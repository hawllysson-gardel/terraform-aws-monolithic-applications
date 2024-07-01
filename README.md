terraform init
terraform fmt
terraform validate
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars"
terraform destroy -var-file="secrets.tfvars"
