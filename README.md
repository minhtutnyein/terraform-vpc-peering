### ace-hcl-app-aws



## AWS VPC + VPC Peering with Terraform (Local Backend)
This repository provisions two independent VPCs (`dev_vpc` and `uat_vpc`) and establishes a VPC peering connection between them.  
The setup is designed to run **entirely on your local machine** using the **default local backend** (no Terraform Cloud workspaces required).

## 📂 Project Structure
```bash
├── dev-vpc                 #dev_vpc/#Root module to create DEV VPC
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
├── file                    #EC2 user_data file directory
│   └── deploy_app.sh
├── hellocloud-app-aws      #hellocloud-app-aws/#Child moudle that provisions a VPC, subnets, Keypair, SGs, EC2, etc.
│   ├── data.tf
│   ├── instance.tf
│   ├── keypair.tf
│   ├── outputs.tf
│   ├── variables.tf
│   ├── versions.tf
│   └── vpc.tf
├── uat-vpc                 #uat_vpc/#Root module to create UAT VPC
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
└── vpc_peering             #vpc_peering/#Root module to create VPC Peering between DEV and UAT
    ├── maint.tf
    ├── outputs.tf
    └── versions.tf
```

## 🚀 Workflow

### 1. Create DEV VPC
```bash
cd ../dev-vpc
terraform init
terraform validate
terraform plan
terraform apply
```
This provisions:
- DEV VPC
- VPC Cidr
- Subnet
- EIP
- Internet Gateway
- Route Tables
- Keypair
- Security Group
- EC2 Instance

Outputs (store in ```terraform.tfstate```)
- app_url
- app_ip
- keypair
- vpc_id
- vpc_cidr
- route_table_id

### 2. Create UAT VPC
```bash
cd ../uat-vpc
terraform init
terraform validate
terraform plan
terraform apply
```
This provisions:
- UAT VPC
- VPC Cidr
- Subnet
- EIP
- Internet Gateway
- Route Tables
- Keypair
- Security Group
- EC2 Instance

Outputs (store in ```terraform.tfstate```)
- app_url
- app_ip
- keypair
- vpc_id
- vpc_cidr
- route_table_id

### 3. Create VPC Peering
```bash
cd ../vpc_peering
terraform init
terraform validate
terraform plan
terraform apply
```
This step:
- Reads ```dev-vpc/terraform.tfstate``` and ```uat-vpc/terraform.tfsate```
- Creates a VPC Peering Connection between DEV and UAT and auto-accept
- Adds routes to both VPC's route tables so that they can communicate

Outputs
- peering_connection_id
- peering_connection_status
- peering_connection_tags
- peering_details which were include connection_id, status, both vpc_id, etc.

## 🛠 Commands Reference
- Validate configuration:
```bash
terraform validate
```
- View planned changes:
```bash
terraform plan
```
- Apply changes:
```bash
terraform apply
```
- Show current outputs:
```bash
terraform output
```
- Show terrafrom state:
```bash
terrafrm show
```
- Show terraform modules:
```bash
terraform state show
```
- Destroy resources:
```bash
terrafrom destroy
```

## 📌 Future Improvements

If you later migrate to Terraform Cloud or an S3 remote backend, you can:
- Replace the ```backend "local"``` blocks with ```backend "remote"``` or ```backend "s3"```.
- Create separate workspaces (```dev_vpc```,```uat_vpc```,```vpc_peering```) in Terraform Cloud for RBAC & collaboration.
For now, this setup is single-user local only.



