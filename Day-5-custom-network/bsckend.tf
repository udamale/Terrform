terraform {
  backend "s3" {
    bucket = "udamale.xyz"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}