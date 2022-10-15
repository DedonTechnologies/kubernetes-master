terraform {
  backend "s3" {
    bucket = "cf-templates-ckidscd3aa3f-us-east-1"
    key   = "s3/terraform.tfstate"
    region = "us-east-1"
 }
}