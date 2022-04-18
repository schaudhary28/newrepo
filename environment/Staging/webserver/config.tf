terraform {
  backend "s3" {
    bucket = "staging-project-acs730"
    key    = "staging/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}