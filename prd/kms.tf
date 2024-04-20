# KMS作成
resource "aws_kms_key" "tfpipeline" {
  policy = templatefile("policy/prd-tfpipeline-kms.json", {
    account_id  = "${var.account_id}",
    account_dev = "${var.account_dev}",
    pj          = "${var.pj}"
    env         = "${var.env}"
  })
  enable_key_rotation = true
}

# KMSエイリアス作成
resource "aws_kms_alias" "tfpipeline" {
  name          = "alias/${var.env}-${var.pj}-kms"
  target_key_id = aws_kms_key.tfpipeline.key_id
}