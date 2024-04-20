# IAMポリシー
resource "aws_iam_policy" "admin_code" {
  name = "${var.env}-${var.pj}-admin-code-policy"
  path = "/"
  policy = templatefile("policy/prd-tfpipeline-admin-code-policy.json", {
    account_id = "${var.account_id}"
    env        = "${var.env}",
    pj         = "${var.pj}"
  })
}

# IAMグループ
resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_policy_attachment" "admin_readonlyaccess" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "operator_code" {
  group      = aws_iam_group.admin.name
  policy_arn = aws_iam_policy.admin_code.arn
}
