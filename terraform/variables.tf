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
  default     = ["master", "worker1"]
  description = "list of instance names"
}

variable "instance_count" {
  type        = number
  default     = 2
  description = "Number of instance to create"
}

variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  default     = "kanban"
  description = "key name"
}
