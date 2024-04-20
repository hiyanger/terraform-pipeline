module "common" {
  source = "../modules/common"

  account_id = var.account_id
  pj         = var.pj
  env        = var.env
}
