## Hidden values due to security reason

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  default     = "---------------"
}

variable "aws_secret_key" {
  description = "AWS Access Key"
  type        = string
  default     = "---------------"
}


variable "acm_domain" {
  description = "AWS Access Key"
  type        = string
  default     = "bhavya-test.com"  
}

variable "aws-route53-name" {
  description = "AWS Access Key"
  type        = string
  default     = "bhavya-test.com"  
}

variable "vpc-id" {
  description = "AWS Access Key"
  type        = string
  default     = "-------------"
}
variable "subnets" {
  type    = list(string)
  default = ["----------------"]
}

variable "acm-cert" {
  description = "AWS Access Key"
  type        = string
  default     = "---------------"  
}
