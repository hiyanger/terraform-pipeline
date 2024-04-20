# ------------------------------
# IAMポリシー
# ------------------------------

# operator
resource "aws_iam_policy" "operator_code" {
  name = "${var.env}-${var.pj}-operator-code-policy"
  path = "/"
  policy = templatefile("policy/dev-tfpipeline-operator-code-policy.json", {
    account_id = "${var.account_id}"
    env        = "${var.env}",
    pj         = "${var.pj}"
  })
}

# ------------------------------
# IAMグループ
# ------------------------------

# admin
resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_policy_attachment" "admin_poweruseraccess" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group_policy_attachment" "admin_readonlyaccess" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

# operator
resource "aws_iam_group" "operator" {
  name = "operator"
}

resource "aws_iam_group_policy_attachment" "operator_code" {
  group      = aws_iam_group.operator.name
  policy_arn = aws_iam_policy.operator_code.arn
}
