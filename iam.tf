# CodePipeline IAM
data "aws_iam_role" "existing_codepipeline_role" {
  name = "codepipeline_role"
}

data "aws_iam_policy" "existing_codepipeline_policy" {
  name = "codepipeline_policy"
}

resource "aws_iam_role" "codepipeline_role" {
  count = data.aws_iam_role.existing_codepipeline_role.id == "" ? 1 : 0

  name = "codepipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy" "codepipeline_policy" {
  count = data.aws_iam_policy.existing_codepipeline_policy.id == "" ? 1 : 0

  name        = "codepipeline_policy"
  description = "Policy for CodePipeline to access S3 and CodeBuild"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ],
        Resource = [
          "${aws_s3_bucket.artifact_bucket.arn}",
          "${aws_s3_bucket.artifact_bucket.arn}/*",
        ],
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  count = (data.aws_iam_role.existing_codepipeline_role.id == "" && data.aws_iam_policy.existing_codepipeline_policy.id == "") ? 1 : 0

  role       = aws_iam_role.codepipeline_role[0].name
  policy_arn = aws_iam_policy.codepipeline_policy[0].arn
}

# CodeDeploy IAM
data "aws_iam_role" "existing_codedeploy_role" {
  name = "codedeploy_role"
}

data "aws_iam_policy" "existing_codedeploy_policy" {
  name = "codedeploy_policy"
}

resource "aws_iam_role" "codedeploy_role" {
  count = data.aws_iam_role.existing_codedeploy_role.id == "" ? 1 : 0

  name = "codedeploy_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy" "codedeploy_policy" {
  count = data.aws_iam_policy.existing_codedeploy_policy.id == "" ? 1 : 0

  name        = "codedeploy_policy"
  description = "Policy for CodeDeploy to interact with EC2 instances and S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
        ],
        Resource = [
          "${aws_s3_bucket.artifact_bucket.arn}",
          "${aws_s3_bucket.artifact_bucket.arn}/*",
        ],
      },
      {
        Effect = "Allow",
        Action = [
          "codedeploy:ListApplications",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetDeploymentGroup",
          "codedeploy:CreateDeployment",
          "codedeploy:UpdateDeploymentGroup",
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  count = (data.aws_iam_role.existing_codedeploy_role.id == "" && data.aws_iam_policy.existing_codedeploy_policy.id == "") ? 1 : 0

  role       = aws_iam_role.codedeploy_role[0].name
  policy_arn = aws_iam_policy.codedeploy_policy[0].arn
}

# CodeBuild IAM
data "aws_iam_role" "existing_codebuild_role" {
  name = "codebuild_role"
}

data "aws_iam_policy" "existing_codebuild_policy" {
  name = "codebuild_policy"
}

resource "aws_iam_role" "codebuild_role" {
  count = data.aws_iam_role.existing_codebuild_role.id == "" ? 1 : 0

  name = "codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  count = data.aws_iam_policy.existing_codebuild_policy.id == "" ? 1 : 0

  name        = "codebuild_policy"
  description = "Policy for CodeBuild to access S3 and CodeCommit"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "codecommit:GetRepository",
          "codecommit:GitPull",
        ],
        Resource = [
          "${aws_s3_bucket.artifact_bucket.arn}",
          "${aws_s3_bucket.artifact_bucket.arn}/*",
          "${aws_codecommit_repository.airline_booking_repo.arn}",
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  count = (data.aws_iam_role.existing_codebuild_role.id == "" && data.aws_iam_policy.existing_codebuild_policy.id == "") ? 1 : 0

  role       = aws_iam_role.codebuild_role[0].name
  policy_arn = aws_iam_policy.codebuild_policy[0].arn
}

# Default IAM
data "aws_iam_role" "existing_role" {
  name = "role_name"
}

data "aws_iam_policy" "existing_policy" {
  name = "example-policy"
}

resource "aws_iam_role" "role_name" {
  count = data.aws_iam_role.existing_role.id == "" ? 1 : 0

  name = "role_name"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "codebuild.amazonaws.com",
            "codedeploy.amazonaws.com",
            "codepipeline.amazonaws.com",
            "ec2.amazonaws.com",
            "s3.amazonaws.com",
          ],
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy" "policy_name" {
  count = data.aws_iam_policy.existing_policy.id == "" ? 1 : 0

  name        = "example-policy"
  description = "An example policy for accessing an S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::s3-kmhyuk0831-01",
          "arn:aws:s3:::s3-kmhyuk0831-01/*",
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "attachment_name" {
  count = (data.aws_iam_role.existing_role.id == "" && data.aws_iam_policy.existing_policy.id == "") ? 1 : 0

  role       = aws_iam_role.role_name[0].name
  policy_arn = aws_iam_policy.policy_name[0].arn
}