# ------------------------------
# CodeCommit
# ------------------------------

# 信頼ポリシー
data "aws_iam_policy_document" "codecommit" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_prd}:root"]
    }
  }
}

# IAMポリシー
resource "aws_iam_policy" "codecommit" {
  name = "${var.env}-${var.pj}-codecommit-policy"
  path = "/"
  policy = templatefile("policy/dev-tfpipeline-codecommit-policy.json", {
    account_id           = "${var.account_id}",
    account_prd          = "${var.account_prd}",
    env                  = "${var.env}",
    env_prd              = "${var.env_prd}",
    pj                   = "${var.pj}"
    prd_tfpipeline_kmsid = "${var.prd_tfpipeline_kmsid}"
  })
}

# IAMロール
resource "aws_iam_role" "codecommit" {
  name               = "${var.env}-${var.pj}-codecommit-role"
  assume_role_policy = data.aws_iam_policy_document.codecommit.json
}

resource "aws_iam_role_policy_attachment" "codecommit_policy" {
  role       = aws_iam_role.codecommit.name
  policy_arn = aws_iam_policy.codecommit.arn
}

# ------------------------------
# CodePipelione
# ------------------------------

# IAMポリシー
resource "aws_iam_policy" "codepipeline" {
  name = "${var.env}-${var.pj}-codepipeline-policy"
  path = "/"
  policy = templatefile("policy/${var.env}-${var.pj}-codepipeline-policy.json", {
    account_id = "${var.account_id}"
    pj         = "${var.pj}",
    env        = "${var.env}"
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
  name               = "dev-tfpipeline-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}