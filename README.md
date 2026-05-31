My CloudVPN - AWS + Wireguard + Terraform

##What does it do?

Deployys a production-grade VPN on  AWS utilising wireguard with a fully automated with Terrfrom IaC

##Architecture 
- AWS EC2 instance on (Ubuntu 22.04 as thge VPN Server)
- Wireguard for encrypted peer-to-peer tunneling
- VPC with pub. subnet, internet gateway and route table
- Security groups restricting traffic to WireGuard UDP port 51820
- SSH key pair for secure server access
- Terraform modules for repeatable, version-controlled deployment

## Results
- Reduced infrastructure provisioning to under 2 minutes via Terraform
- Achieved encrypted remote connectivity across distributed environments
- Cut infrastructure costs by 33% through reusable IaC module design

## How to deploy
terraform init
terraform plan
terraform apply

## How to destroy
terraform destroy
