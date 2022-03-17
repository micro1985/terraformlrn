# Auto Fill parameters for PROD

#File can be named as:
# terraform.tfvars
# *.auto.tfvars / prod.auto.tfvars / dev.auto.tfvars

region                     = "us-east-2"
instance_type              = "t3.micro"
enable_detailed_monitoring = false

allow_ports = ["80", "22", "8080", "443"]

common_tags = {
  Owner       = "xenn"
  Project     = "Valim"
  Environment = "DEV"
}
