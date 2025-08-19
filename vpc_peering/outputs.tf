# Peering Connection Information
output "peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.dev_to_uat.id
}

output "peering_connection_status" {
  description = "The status of the VPC peering connection"
  value       = aws_vpc_peering_connection.dev_to_uat.accept_status
}

output "peering_connection_tags" {
  description = "The tags assigned to the peering connection"
  value       = aws_vpc_peering_connection.dev_to_uat.tags_all
}

# Combined Information (useful for other modules)
output "peering_details" {
  description = "All peering details in a map"
  value = {
    connection_id = aws_vpc_peering_connection.dev_to_uat.id
    status        = aws_vpc_peering_connection.dev_to_uat.accept_status
    dev_vpc = {
      id          = data.terraform_remote_state.dev_vpc.outputs.vpc_id
      cidr        = data.terraform_remote_state.dev_vpc.outputs.vpc_cidr
      route_table = data.terraform_remote_state.dev_vpc.outputs.route_table_id
    }
    uat_vpc = {
      id          = data.terraform_remote_state.uat_vpc.outputs.vpc_id
      cidr        = data.terraform_remote_state.uat_vpc.outputs.vpc_cidr
      route_table = data.terraform_remote_state.uat_vpc.outputs.route_table_id
    }
  }
}
