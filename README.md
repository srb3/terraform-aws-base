# Overview
This module creates a base set of resources for AWS EC2. It is intended to be used as a starting point for other modules that connect to pre-created ec2 virtual machines. By default the module wil create:
  * vpc (with subnets)
  * security group
  * vm

if you pass through the id for a `vpc`, `security_group` or subnets then they will not be created, and rather passed through to the vm that is going to be created. The number of virtual machines to create is controlled by the `vm_instance_count` variable.

#### Supported platform families:
 * AWS EC2

## Usage

#### minimal:
the config below will create
  * 1 x vpc (with 1 public subnet on 10.0.0.0/24)
  * 1 x security_group (with 22, 80, and 443 open to 0.0.0.0/0 on ingress and egress open all ports to 0.0.0.0/0)
  * 1 x vm using attached to the subnet id created for the vpc and using the security group created, the vm will use the ssh key specified in `vm_key_name`
note: if `base_create` is not set it will default to false
```hcl

module "create_base" {
  source          = "srb3/base/aws"
  version         = "0.0.1"
  vm_key_name     = "eu-west-1-key"
  base_create     = true 
}
```

#### use existing vpc and subnet:
use an existing vpc and subnet by providing the ids, but create a new security group with non default rules and a new vm
```hcl

locals {
  ingress_rules = [
    { from_port = 8080, to_port = 8085, protocol = "tcp", cidr_blocks = "203.0.113.0/24" },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = "203.0.113.0/24" }
  ]
}

module "create_base" {
  source                                  = "srb3/base/aws"
  version                                 = "0.0.1"
  vm_key_name                             = "eu-west-1-key"
  base_create                             = true 
  vpc_id                                  = "vpc-12345"
  subnet_ids                              = ["subnet-12345"]
  security_group_ingress_with_cidr_blocks = local.ingress_rules
}
```
