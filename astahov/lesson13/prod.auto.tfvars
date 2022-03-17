# Auto Fill parameters for PROD

#File can be named as:
# terraform.tfvars
# *.auto.tfvars / prod.auto.tfvars / dev.auto.tfvars

region                     = "us-east-1"
instance_type              = "t3.large"
enable_detailed_monitoring = true

allow_ports = ["80", "8080", "443"]

common_tags = {
  Owner       = "xenn"
  Project     = "Valim"
  Environment = "Production"
}
