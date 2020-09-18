data "aws_availability_zones" "available" {}

resource "random_id" "hash" {
  byte_length = 4
}

module "ami" {
  source  = "srb3/ami/aws"
  version = "0.13.0"
  os_name = var.vm_os_name
}

locals {
  prefix         = var.base_name_prefix != null ? var.base_name_prefix : random_id.hash.hex
  create_vpc     = var.base_create ? var.vpc_id == null ? true : false : false
  create_sg      = var.base_create ? var.vm_security_group_ids == null ? true : false :false
  instance_count = var.base_create ? var.vm_instance_count : 0
  vpc_name       = "${local.prefix}-${var.vpc_name}"
  sec_grp_name   = "${local.prefix}-${var.security_group_name}"
  vm_name        = "${local.prefix}-${var.vm_name}"
  ami_id         = var.vm_ami_id != null ? var.vm_ami_id : module.ami.id
  ssh_user       = var.vm_ami_id != null ? var.vm_ssh_user != null ? var.vm_ssh_user : "root" : module.ami.user
  sec_grp_ids    = var.vm_security_group_ids != null ? var.vm_security_group_ids : [module.security_group.id]
  vpc_id         = var.vpc_id != null ? var.vpc_id : module.vpc.vpc_id
  subnet_ids     = var.vm_subnet_ids != null ? var.vm_subnet_ids : module.vpc.public_subnets
  azs            = length(var.vpc_azs) > 0 ? var.vpc_azs : [
                                           data.aws_availability_zones.available.names[0],
                                           data.aws_availability_zones.available.names[1]
                                         ]
  rbd            = var.vm_root_block_device != null ? var.vm_root_block_device : [
                                           { volume_type = "gp2", volume_size = "40" }
                                         ]
  ebd            = var.vm_ebs_block_device != null ? var.vm_ebs_block_device : []
  cidr           = var.security_group_access_cidrs != null ? var.security_group_access_cidrs : ["0.0.0.0/0"]
  iwcb           = length(var.security_group_ingress_with_cidr_blocks) > 0 ? var.security_group_ingress_with_cidr_blocks : [
    { rule = "ssh-tcp", cidr_blocks = join(",",local.cidr) },
    { rule = "http-80-tcp", cidr_blocks = join(",",local.cidr) },
    { rule = "https-443-tcp", cidr_blocks = join(",",local.cidr) }
  ]
  ewcb           = length(var.security_group_egress_with_cidr_blocks) > 0 ? var.security_group_egress_with_cidr_blocks : [
    { rule = "all-all", cidr_blocks = "0.0.0.0/0" }
  ]
}

module "vpc" {
  source             = "srb3/vpc/aws"
  version            = "0.13.0"
  create_vpc         = local.create_vpc
  name               = local.vpc_name
  cidr               = var.vpc_cidr
  azs                = local.azs
  private_subnets    = var.vpc_private_subnets
  public_subnets     = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  tags               = var.tags
}

module "security_group" {
  source                   = "srb3/security-group/aws"
  version                  = "0.13.0"
  create                   = local.create_sg
  name                     = local.sec_grp_name
  description              = var.security_group_description
  vpc_id                   = local.vpc_id
  ingress_with_cidr_blocks = local.iwcb
  ingress_cidr_blocks      = var.security_group_ingress_cidr_blocks
  egress_with_cidr_blocks  = local.ewcb
  egress_cidr_blocks       = var.security_group_egress_cidr_blocks
  tags                     = var.tags
}

module "instance" {
  source                      = "srb3/vm/aws"
  version                     = "0.13.0"
  name                        = local.vm_name
  ami                         = local.ami_id
  instance_count              = local.instance_count
  instance_type               = var.vm_instance_type
  key_name                    = var.vm_key_name
  security_group_ids          = local.sec_grp_ids
  subnet_ids                  = local.subnet_ids
  root_block_device           = local.rbd
  ebs_block_device            = local.ebd
  associate_public_ip_address = var.vm_associate_public_ip_address
  tags                        = var.tags
}
