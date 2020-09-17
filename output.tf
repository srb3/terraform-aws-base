output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = flatten(module.instance.*.public_dns)
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = flatten(module.instance.*.public_ip)
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = flatten(module.instance.*.private_dns)
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = flatten(module.instance.*.private_ip)
}

output "ssh_user" {
  description = "The ssh user name for the created instance/s"
  value       = local.ssh_user
}

output "public_subnet_ids" {
  description = "A list of public subnet ids associated with this vpc"
  value       = local.subnet_ids
}

output "sec_grp_ids" {
  description = "A list of security groups associated with this vpc"
  value       = local.sec_grp_ids
}

output "vpc_id" {
  description = "A list of security groups associated with this vpc"
  value       = local.vpc_id
}
