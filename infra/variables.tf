variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1" # Mumbai
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}
