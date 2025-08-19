### Outputs File
output "hellocloud_app_url" {
  value = module.dev_vpc.hellocloud_app_url
}

output "hellocloud_app_ip" {
  value = module.dev_vpc.hellocloud_app_ip
}

output "hellocloud_instance_private_key" {
  value     = module.dev_vpc.hellocloud_instance_private_key
  sensitive = true
}

output "vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "vpc_cidr" {
  value = module.dev_vpc.vpc_cidr
}

output "route_table_id" {
  value = module.dev_vpc.route_table_id
}
