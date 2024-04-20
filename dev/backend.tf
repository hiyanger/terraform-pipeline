terraform {
  backend "s3" {
    bucket         = "dev-tfpipeline-tfstate-bucket"
    dynamodb_table = "dev-tfpipeline-table"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    # profile        = ""
  }
}
