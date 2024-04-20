# ------------------------------
# S3 Artifact
# ------------------------------

# バケット作成
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.env}-${var.pj}-artifact-bucket"
}

# バケットポリシー
resource "aws_s3_bucket_policy" "artifact" {
  bucket     = aws_s3_bucket.artifact.id
  depends_on = [aws_s3_bucket.artifact]
  policy = templatefile("policy/${var.env}-${var.pj}-artifact-bucket.json", {
    env = "${var.env}",
    pj  = "${var.pj}"
  })
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