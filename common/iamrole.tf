# 信頼ポリシー
data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# ------------------------------
# CodeBuild plan
# ------------------------------

# IAMポリシー
resource "aws_iam_policy" "codebuild_plan" {
  name = "${var.env}-${var.pj}-codebuild-plan-policy"
  path = "/"
  policy = templatefile("../modules/common/policy/${var.pj}-codebuild-plan-policy.json", {
    account_id = "${var.account_id}"
    pj         = "${var.pj}",
    env        = "${var.env}"
  })
}

# IAMロール
resource "aws_iam_role" "codebuild_plan" {
  name               = "${var.env}-${var.pj}-codebuild-plan-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild_plan" {
  role       = aws_iam_role.codebuild_plan.name
  policy_arn = aws_iam_policy.codebuild_plan.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_plan_ReadOnlyAccess" {
  role       = aws_iam_role.codebuild_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# ------------------------------
# CodeBuild apply
# ------------------------------

# IAMロール
resource "aws_iam_role" "codebuild_apply" {
  name               = "${var.env}-${var.pj}-codebuild-apply-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild_apply_PowerUserAccess" {
  role       = aws_iam_role.codebuild_apply.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_apply_IAMFullAccess" {
  role       = aws_iam_role.codebuild_apply.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}