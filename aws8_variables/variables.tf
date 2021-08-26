variable "region" {
  description = "AWS Region"
  default     = "eu-north-1"
}
variable "instance_type" {
  description = "Instance Type"
  default     = "t3.micro"
}
variable "allow_ports" {
  description = "List of ports to open"
  type        = list(any)
  default     = ["80", "443", "22"]
}
variable "detailed_monitoring" {
  description = "Detailed Monitoring"
  type        = bool
  default     = "true"
}
variable "common_tags" {
  description = "Common Tags"
  type        = map(any)
  default = {
    Owner   = "Sasha Gatsiha"
    Project = "GEKOTENHEYER"
  }
}