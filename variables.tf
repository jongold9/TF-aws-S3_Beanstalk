# Объявление переменных
variable "aws_region" {
  description = "AWS Region"
  default     = "eu-central-1"
}

variable aws_access_key {
  type    = string
  description = "AWS Access Key"
}

variable aws_secret_key {
  type    = string
  description = "AWS Secret Key"
}
