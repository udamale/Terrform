terraform {
  backend "s3" {
    bucket = "udamale.xyz"
    key = "Day 4/terraform.tfstate"
    region = "ap-south-1"
  }
}