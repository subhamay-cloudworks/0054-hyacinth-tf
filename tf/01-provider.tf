terraform {
  backend "s3" {
    bucket = "subhamay-tf-remote-state-us-east-1"             // Bucket where to SAVE Terraform State
    key    = "0054-hyacinth/devl/s3-bucket/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                                      // Region where bucket created
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}