variable "vpc_id" {
  type        = string
  description = "VPC to use"
  default     = "vpc-d3d309ba"
}

variable "instance_type" {
  description = ""
  default     = "t2.micro"
  type        = string
}

variable "subnet_id" {
}

variable "tags" {
}

variable "common_tags" {
  description = "Tags to apply to all AWS resources"
  type        = map(string)
  default     = { "owner_tag" = "mike.green" }
}
