# ------------------------------
# CodePipelione
# ------------------------------

# IAMポリシー
resource "aws_iam_policy" "codepipeline" {
  name = "${var.env}-${var.pj}-codepipeline-policy"
  path = "/"
  policy = templatefile("policy/${var.env}-${var.pj}-codepipeline-policy.json", {
    account_id  = "${var.account_id}"
    account_dev = "${var.account_dev}"
    pj          = "${var.pj}",
    env         = "${var.env}"
  })
}

# 信頼ポリシー
data "aws_iam_policy_document" "codepipeline" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

# IAMロール
resource "aws_iam_role" "codepipeline" {
  name               = "prd-tfpipeline-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}