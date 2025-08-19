# vpc_peering/main.tf

# Reference existing dev VPC state
data "terraform_remote_state" "dev_vpc" {
  backend = "local"
  config = {
    path = "../dev-vpc/terraform.tfstate"
  }
}

# Reference existing uat VPC state
data "terraform_remote_state" "uat_vpc" {
  backend = "local"
  config = {
    path = "../uat-vpc/terraform.tfstate"
  }
}

# Create VPC peering connection
resource "aws_vpc_peering_connection" "dev_to_uat" {
  peer_vpc_id = data.terraform_remote_state.uat_vpc.outputs.vpc_id
  vpc_id      = data.terraform_remote_state.dev_vpc.outputs.vpc_id
  auto_accept = true # Set to false for cross-account peering

  tags = {
    Name = "dev-to-uat-peering"
  }
}

# Add route in dev VPC to uat VPC
resource "aws_route" "dev_to_uat" {
  route_table_id            = data.terraform_remote_state.dev_vpc.outputs.route_table_id
  destination_cidr_block    = data.terraform_remote_state.uat_vpc.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.dev_to_uat.id
}

# Add route in uat VPC to dev VPC
resource "aws_route" "uat_to_dev" {
  route_table_id            = data.terraform_remote_state.uat_vpc.outputs.route_table_id
  destination_cidr_block    = data.terraform_remote_state.dev_vpc.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.dev_to_uat.id
}