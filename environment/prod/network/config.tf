
terraform {
  backend "s3" {
    bucket = "prod-project-acs730"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}