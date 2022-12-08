variable "aws_vpc_name" {
  default = "final"
  type    = string
}
variable "cidr_block_range" {
  default = "10.100.0.0/16"
}

variable "env" {
  default = "dev"
}


variable "cider_block" {
  type = map(list(object({
    item   = number,
    zone   = string,
    ip     = string,
    public = bool
  })))


  default = {
    sub = [
      { item = 1, zone = "us-east-1b", ip = "10.100.0.0/19", public = true },
      { item = 2, zone = "us-east-1b", ip = "10.100.32.0/19", public = false },
      { item = 3, zone = "us-east-1c", ip = "10.100.64.0/19", public = true },
      { item = 4, zone = "us-east-1c", ip = "10.100.96.0/19", public = false },
      { item = 5, zone = "us-east-1d", ip = "10.100.128.0/19", public = true },
      { item = 6, zone = "us-east-1d", ip = "10.100.160.0/19", public = false }
  ] }
}

######autoscaling variable

variable "image_id" {
  default = "ami-0ac8ec06ffedcd1b5"
}

variable "instanceType" {
  default = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
  type = map(string)
}

variable "keyName" {
  default = "/home/ec2-user/.ssh/id_rsa"
  type    = string
}

variable "vmprefix" {
  default = "id_rsa"
}
