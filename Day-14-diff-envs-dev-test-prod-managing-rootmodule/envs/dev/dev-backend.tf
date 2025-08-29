
terraform {
  backend "s3" {
    bucket         = "udamale.xyz"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = true
    
  }
}
