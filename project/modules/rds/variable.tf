variable "identifier" { type = string }
variable "engine" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "username" { type = string }
variable "password" { 
    type = string 
    sensitive = true 
    
    }

variable "subnet_ids" { type = list(string) }
variable "vpc_security_group_ids" { type = list(string) }
