# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

output "vpc_id" {
  description = "VPC ID"
  value       = local.con
}

output "mgmt_interface" {
  description = "Mgmt interface id"
  value       = aws_network_interface.ftd_mgmt.*.id
}

output "outside_interface" {
  description = "Outside interface id"
  value       = aws_network_interface.ftd_outside.*.id
}

output "inside_interface" {
  description = "Inside interface id"
  value       = aws_network_interface.ftd_inside.*.id
}

output "diag_interface" {
  description = "Diag interface id"
  value       = aws_network_interface.ftd_diag.*.id
}

output "fmcmgmt_interface" {
  description = "FMC Mgmt interface id"
  value       = var.create_fmc ? aws_network_interface.fmcmgmt[0].id : null
}

output "mgmt_subnet" {
  description = "Mgmt Subnet id"
  value       = local.mgmt_subnet.*.id
}

output "inside_subnet" {
  description = "Inside Subnet id"
  value       = local.inside_subnet
}

output "outside_subnet" {
  description = "Outside Subnet id"
  value       = local.outside_subnet.*.id
}

output "diag_subnet" {
  description = "Diag Subnet id"
  value       = local.diag_subnet
}

output "mgmt_interface_ip" {
  description = "Mgmt Interface IP"
  value       = aws_network_interface.ftd_mgmt.*.private_ip_list
}

output "inside_interface_ip" {
  description = "Inside Interface IP"
  value       = aws_network_interface.ftd_inside.*.private_ip_list
}

output "outside_interface_ip" {
  description = "outside Interface IP"
  value       = aws_network_interface.ftd_outside.*.private_ip_list
}

output "diag_interface_ip" {
  description = "Diag Interface IP"
  value       = aws_network_interface.ftd_diag.*.private_ip_list
}

output "fmc_interface_ip" {
  description = "FMC Interface IP"
  value       = var.create_fmc ? aws_network_interface.fmcmgmt.*.private_ip_list : null
}

output "internet_gateway" {
  description = "Internet Gateway ID"
  value       = var.create_igw ? aws_internet_gateway.int_gw.*.id : data.aws_internet_gateway.default.*.internet_gateway_id
}

output "mgmt_rt_id" {
  description = "Mgmt subnet Route table ID"
  value       = aws_route_table.ftd_mgmt_route.*.id
}