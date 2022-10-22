terraform {
  backend "s3" {
    bucket = "soso-bucket1"
    key   = "s3/terraform.tfstate"
    region = "us-east-1"
 }
}