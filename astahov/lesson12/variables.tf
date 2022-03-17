variable "region" {
  description = "Enter AWS Region to Deploy"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Enter AWS Instance Type to Deploy"
  type        = string
  default     = "t3.micro"
}

variable "allow_ports" {
  description = "List of Ports to Open"
  type        = list(any)
  default     = ["80", "443", "22"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "common_tags" {
  type = map(any)
  default = {
    owner       = "xenn"
    Project     = "Valim"
    Environment = "Development"
  }
}
