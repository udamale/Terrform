# provider "aws" {
  
# }

# variable "aws_region" {
#   type = string
#   nullable = false
#   default = "ap-south-1"
#   validation {
#     condition = var.aws_region =="ap-south-1" || var.aws_region =="us-west-2" ||var.aws_region =="eu-west-1"
#     error_message = "The variable 'aws_rerion' must be one the following 'ap-south-1', 'us-west-2' and 'eu-west-1'"  
#   }
# }

# resource "aws_s3_bucket" "name" {
#   bucket = "udamale.xyz"
#   region = var.aws_region
# }

#after run this will get error like The variable 'aws_region' must be one of the following regions: us-west-2,│ eu-west-1, so it will allow any one region defined above in conditin block



# exapmle 2

variable "create_bucket" {
  type = bool
  default = true
}

resource "aws_s3_bucket" "prod" {
  bucket = "udamale.xyz"
  count = var.create_bucket ? 1 : 0

}

# Example -3 
resource "aws_instance" "prod" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = "t2.micro"
  subnet_id = "subnet-09f113a76bbdf6b91"
  count = var.environment =="prod" ? 3 : 1
  tags = {
    Name = "prod-${count.index}"
  }
}

variable "environment" {
  type = string
  // default = "dev"  # optional, if you want a fallback
}

#In this case:
#If var.environment == "prod" → count = 3
#Else (like dev, qa, etc.) → count = 1

#terraform apply -var="environment=dev"