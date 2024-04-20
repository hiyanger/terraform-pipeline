provider "aws" {
  region  = "ap-northeast-1"
  # profile = ""

}

terraform {
  required_version = "= 1.7.5"
  required_providers {
    aws = "= 5.42.0"
  }
}