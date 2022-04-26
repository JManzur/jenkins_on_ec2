#JManzur - 06/2021
#Deploy VPC using AWS VPC Module 
#Registry: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "demo-vpc"
  cidr = "10.48.0.0/16"

  #AZ's and Subnets Definition
  azs             = ["${var.aws_region}a"]
  private_subnets = ["10.48.10.0/24"]
  public_subnets  = ["10.48.20.0/24"]

  tags                = merge(var.project-tags, { Name = "${var.resource-name-tag}-vpc" }, )
  private_subnet_tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-private_subnet" }, )
  public_subnet_tags  = merge(var.project-tags, { Name = "${var.resource-name-tag}-public_subnet" }, )

  #Deny Access to DB subnet form public subnet
  create_database_subnet_group = false

  #Routing tables 
  manage_default_route_table = true

  default_route_table_tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-rt" }, )
  private_route_table_tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-private_rt" }, )
  public_route_table_tags  = merge(var.project-tags, { Name = "${var.resource-name-tag}-public_rt" }, )

  #Nat Gateway
  enable_nat_gateway = true
  single_nat_gateway = true

  nat_gateway_tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-ng" }, )

  #Deny all SG:
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  default_security_group_tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-sg" }, )

  #VPC Flow Logs 
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  vpc_flow_log_tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-vpc_logs" }, )
}

## Data Sources declarations ##
## Fetch the vpc id to print and use the output
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Jenkins-vpc"]
  }

  depends_on = [module.vpc]
}

## Fetch the public subnets ids to print and use the output
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["Jenkins-public_subnet"]
  }

  depends_on = [module.vpc]
}

## Fetch the privates subnets ids to print and use the output
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["Jenkins-private_subnet"]
  }
  depends_on = [module.vpc]
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids
  id       = each.value
}

##VPC output
output "vpc-id" {
  value       = data.aws_vpc.selected.id
  description = "Print the VPC ID fetched by vpc.tf"
}

output "public_subnet_ids" {
  value       = [for i in data.aws_subnet.public : i.id]
  description = "Print the public subnets id fetched by vpc.tf"
}

output "private_subnet_ids" {
  value       = [for i in data.aws_subnet.private : i.id]
  description = "Print the private subnets id fetched by vpc.tf"
}