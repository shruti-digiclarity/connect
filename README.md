# ccaas-terraform-connect

terraform init -backend-config="../environments/us-east-1/dev/backend.tfvars"
terraform plan -var-file="../environments/us-east-1/dev/inputs.tfvars"
terraform apply -var-file="../environments/us-east-1/dev/inputs.tfvars"
terraform destroy -var-file="../environments/us-east-1/dev/inputs.tfvars"

terraform init -backend-config="../environments/us-east-1/uat/backend.tfvars"
terraform plan -var-file="../environments/us-east-1/uat/inputs.tfvars"
terraform apply -var-file="../environments/us-east-1/uat/inputs.tfvars"
terraform destroy -var-file="../environments/us-east-1/uat/inputs.tfvars"

chmod +x .terraform/modules/amazon_connect/terraform-aws-amazonconnect-wrapper/scripts/env.sh
dos2unix .terraform/modules/amazon_connect/terraform-aws-amazonconnect-wrapper/scripts/env.sh
