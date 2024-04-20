output "codebuild_plan_arn" {
  value = aws_iam_role.codebuild_plan.arn
}

output "codebuild_apply_arn" {
  value = aws_iam_role.codebuild_apply.arn
}