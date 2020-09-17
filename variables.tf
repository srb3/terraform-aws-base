########### general settings #####################

variable "base_name_prefix" {
  description = "A string to preprend to the names given to resources that are created by this module"
  type        = string
  default     = null
}

variable "base_create" {
  description = "A boolean to dictate if we create an instance"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of key / value pairs to apply to the resources created by this module that accept tags"
  type        = map(string)
}

########### vpc settings #########################

variable "vpc_id" {
  description = "The id of an aws vpc to use for our instnace"
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "The name to give the vpc that will be associated with our instance"
  type        = string
  default     = "omnidemo-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC that will be used by the instance"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region, This is consumed by the vpc module"
  type        = list(string)
  default     = [] 
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

########### security group settings #####S########

variable "security_group_name" {
  description = "The name to give the security group that will be associated with our omnidemo instance"
  type        = string
  default     = "omnidemo-sg"
}

variable "security_group_description" {
  description = "The description to give the security group that will be associated with our omnidemo instance"
  type        = string
  default     = "An omnidemo managed security group"
}

variable "security_group_ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "security_group_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "security_group_egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "security_group_egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "security_group_access_cidrs" {
  description = "A list of CIDR's to allow access to the instance from"
  type        = list(string)
}

########### vm settings ##########################

variable "vm_instance_count" {
  description = "The number of instances to create"
  type        = number
  default     = 1
}

variable "vm_name" {
  description = "The name to give the virtual machine"
  type        = string
  default     = "omnidemo-vm"
}

variable "vm_ami_id" {
  description = "The id of an ami to use. if not used then the os_name value is used to get the latest named image id"
  type        = string
  default     = null
}

variable "vm_ssh_user" {
  description = "If using a custom ami id then set the ssh user in this variable"
  type        = string
  default     = null
}

variable "vm_os_name" {
  description = "The name of the OS to use for the chef autoamte deployment, ignored if ami is used"
  type        = string
  default     = "centos-7"
}

variable "vm_instance_type" {
  description = "The instance type to use for deploying chef autoamte"
  type        = string
  default     = "t3.medium"
}

variable "vm_key_name" {
  description = "The name of the aws ssh key pair to use with the instance"
  type        = string
}

variable "vm_security_group_ids" {
  description = "The id of a security group to associate with, if null then a default security group is created"
  type        = list(string)
  default     = null
}

variable "vm_subnet_ids" {
  description = "A list of ids of subnets to associate with, if null that a default subnet is created"
  type        = list(string)
  default     = null
}

variable "vm_root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(map(string))
  default     = null
}

variable "vm_ebs_block_device" {
  description = "Additional EBS block devices to attach to the instanc"
  type        = list(map(string))
  default     = null
}

variable "vm_associate_public_ip_address" {
  description = "If true, the instance will have associated public IP address"
  type        = bool
  default     = true
}
