terraform {
  backend "s3" {
    bucket         = "prd-tfpipeline-tfstate-bucket"
    dynamodb_table = "prd-tfpipeline-table"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    # profile        = ""
  }
}
