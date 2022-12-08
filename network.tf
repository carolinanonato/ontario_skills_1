
#Create a vpc
resource "aws_vpc" "aws_vpc_name" {
  cidr_block           = var.cidr_block_range
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.env}"
  }
}

locals {
  subnets = flatten([
    for resource in keys(var.cider_block) : [
      for subnet in var.cider_block[resource] : {
        resource          = resource
        number            = subnet.item
        cidr_block        = subnet.ip
        availability_zone = subnet.zone
        public            = subnet.public
      }
    ]
  ])

  subnets_map = {
    for s in local.subnets : "${s.number}" => s
  }
}

resource "aws_subnet" "subnet_block" {
  for_each = local.subnets_map

  vpc_id                  = aws_vpc.aws_vpc_name.id
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public
  cidr_block              = each.value.cidr_block
  tags = {
    Name = "${var.env}-${each.value.number}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.aws_vpc_name.id
  tags = {
    Name = "vpc-${var.aws_vpc_name}"
  }
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet_block[3].id
  tags = {
    Name = "nat gateway"
  }
}