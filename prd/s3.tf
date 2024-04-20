# バケット作成
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.env}-${var.pj}-artifact-bucket"
}

# バケットポリシー
resource "aws_s3_bucket_policy" "artifact" {
  bucket     = aws_s3_bucket.artifact.id
  depends_on = [aws_s3_bucket.artifact]
  policy = templatefile("policy/${var.env}-${var.pj}-artifact-bucket.json", {
    account_dev = "${var.account_dev}",
    pj          = "${var.pj}"
    env         = "${var.env}"
    env_dev     = "${var.env_dev}"
  })
}

# KMS設定
resource "aws_s3_bucket_server_side_encryption_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfpipeline.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# ライフサイクルルール
resource "aws_s3_bucket_lifecycle_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    id = "${var.env}-${var.pj}-artifact-lifecycle"
    expiration {
      days = 30
    }
    status = "Enabled"
  }
}