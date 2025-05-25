variable "openai_api_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS Region"
}
