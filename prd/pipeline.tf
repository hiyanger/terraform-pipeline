# ------------------------------
# CodeBuild
# ------------------------------

# terraform plan
resource "aws_codebuild_project" "plan" {
  name           = "${var.env}-${var.pj}-codebuild-plan"
  service_role   = module.common.codebuild_plan_arn
  encryption_key = "arn:aws:kms:ap-northeast-1:${var.account_id}:key/${var.tfpipeline_kmsid}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "public.ecr.aws/hashicorp/terraform:1.7.5"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "dir"
      value = var.env
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec_plan.yml"
  }
}

# terraform apply
resource "aws_codebuild_project" "apply" {
  name           = "${var.env}-${var.pj}-codebuild-apply"
  service_role   = module.common.codebuild_apply_arn
  encryption_key = "arn:aws:kms:ap-northeast-1:${var.account_id}:key/${var.tfpipeline_kmsid}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "public.ecr.aws/hashicorp/terraform:1.7.5"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "dir"
      value = var.env
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec_apply.yml"
  }
}

# ------------------------------
# CodePipeline
# ------------------------------

resource "aws_codepipeline" "terraform" {
  name     = "${var.env}-${var.pj}-codepipeline"
  role_arn = aws_iam_role.codepipeline.arn

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      role_arn         = "arn:aws:iam::${var.account_dev}:role/${var.env_dev}-${var.pj}-codecommit-role"

      configuration = {
        RepositoryName = "${var.env_dev}-${var.pj}-repository"
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Build-Plan"
    action {
      name             = "terraform-plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.env}-${var.pj}-codebuild-plan"
      }
    }
  }

  stage {
    name = "Approval"
    action {
      name     = "apply-approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Build-Apply"
    action {
      name            = "terraform-apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["plan_output"]
      version         = "1"

      configuration = {
        ProjectName = "${var.env}-${var.pj}-codebuild-apply"
      }
    }
  }

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"

    encryption_key {
      id   = aws_kms_alias.tfpipeline.arn
      type = "KMS"
    }
  }
}