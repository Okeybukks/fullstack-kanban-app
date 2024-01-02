variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "A list of availability zones"
}

variable "cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "A list of CIDR"
}

variable "instance_names" {
  type        = list(string)
  default     = ["master", "worker"]
  description = "list of instance names"
}
