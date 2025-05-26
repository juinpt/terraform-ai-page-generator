variable "openai_api_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS Region"
}

variable "ami" {
  type        = string
  description = "The AMI for the EC2 instances; must be ubuntu"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}
