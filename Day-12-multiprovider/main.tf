provider "aws" {
  region = "ap-south-1"

}

provider "aws" {
  alias = "dev"
#  region = "us-east-2"
  profile = "dev"
}



resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "name" {
  provider = aws.dev
  bucket = "lfkdjogrhjhfiue"
  

  # Optional: publicly accessible configuration

 
}