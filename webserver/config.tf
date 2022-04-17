# S3 Bucket Dev env webseever
terraform {
  backend "s3" {
    bucket = "dev-project-acs730"   
    key    = "dev/webserver/terraform.tfstate" 
    region = "us-east-1"                       
  }
}
