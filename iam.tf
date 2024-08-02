# CodePipeline IAM
# 데이터 소스를 사용하여 기존 IAM 역할의 존재 여부를 확인
data "aws_iam_role" "existing_codepipeline_role" {
  name = "codepipeline_role"
}

# 데이터 소스를 사용하여 기존 IAM 정책의 존재 여부를 확인
data "aws_iam_policy" "existing_codepipeline_policy" {
  name = "codepipeline_policy"
}

# IAM 역할이 존재하지 않는 경우에만 생성
resource "aws_iam_role" "codepipeline_role" {
  count = data.aws_iam_role.existing_codepipeline_role.id != "" ? 0 : 1

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

# IAM 정책 생성
resource "aws_iam_policy" "codepipeline_policy" {
  count = data.aws_iam_policy.existing_codepipeline_policy.id != "" ? 0 : 1

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

# IAM 역할과 정책 연결
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  count = (data.aws_iam_role.existing_codepipeline_role.id != "" && data.aws_iam_policy.existing_codepipeline_policy.id != "") ? 0 : 1

  role       = aws_iam_role.codepipeline_role[0].name
  policy_arn = aws_iam_policy.codepipeline_policy[0].arn
}

# CodeDeploy IAM
# 데이터 소스를 사용하여 기존 IAM 역할의 존재 여부를 확인
data "aws_iam_role" "existing_codedeploy_role" {
  name = "codedeploy_role"
}

# 데이터 소스를 사용하여 기존 IAM 정책의 존재 여부를 확인
data "aws_iam_policy" "existing_codedeploy_policy" {
  name = "codedeploy_policy"
}

# IAM 역할이 존재하지 않는 경우에만 생성
resource "aws_iam_role" "codedeploy_role" {
  count = data.aws_iam_role.existing_codedeploy_role.id != "" ? 0 : 1

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

# IAM 정책 생성
resource "aws_iam_policy" "codedeploy_policy" {
  count = data.aws_iam_policy.existing_codedeploy_policy.id != "" ? 0 : 1

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

# IAM 역할과 정책 연결
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  count = (data.aws_iam_role.existing_codedeploy_role.id != "" && data.aws_iam_policy.existing_codedeploy_policy.id != "") ? 0 : 1

  role       = aws_iam_role.codedeploy_role[0].name
  policy_arn = aws_iam_policy.codedeploy_policy[0].arn
}

# CodeBuild
# 데이터 소스를 사용하여 기존 IAM 역할의 존재 여부를 확인
data "aws_iam_role" "existing_codebuild_role" {
  name = "codebuild_role"
}

# 데이터 소스를 사용하여 기존 IAM 정책의 존재 여부를 확인
data "aws_iam_policy" "existing_codebuild_policy" {
  name = "codebuild_policy"
}

# IAM 역할이 존재하지 않는 경우에만 생성
resource "aws_iam_role" "codebuild_role" {
  count = data.aws_iam_role.existing_codebuild_role.id != "" ? 0 : 1

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

# IAM 정책 생성
resource "aws_iam_policy" "codebuild_policy" {
  count = data.aws_iam_policy.existing_codebuild_policy.id != "" ? 0 : 1

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

# IAM 역할과 정책 연결
resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  count = (data.aws_iam_role.existing_codebuild_role.id != "" && data.aws_iam_policy.existing_codebuild_policy.id != "") ? 0 : 1

  role       = aws_iam_role.codebuild_role[0].name
  policy_arn = aws_iam_policy.codebuild_policy[0].arn
}

# Defalt IAM
# 데이터 소스를 사용하여 기존 IAM 역할의 존재 여부를 확인
data "aws_iam_role" "existing_role" {
  name = "role_name"
}

# 데이터 소스를 사용하여 기존 IAM 정책의 존재 여부를 확인
data "aws_iam_policy" "existing_policy" {
  name = "example-policy"
}

# IAM 역할이 존재하지 않는 경우에만 생성
resource "aws_iam_role" "role_name" {
  count = data.aws_iam_role.existing_role.id != "" ? 0 : 1

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

# IAM 정책 생성
resource "aws_iam_policy" "policy_name" {
  count = data.aws_iam_policy.existing_policy.id != "" ? 0 : 1

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

# IAM 역할과 정책 연결
resource "aws_iam_role_policy_attachment" "attachment_name" {
  count = (data.aws_iam_role.existing_role.id != "" && data.aws_iam_policy.existing_policy.id != "") ? 0 : 1

  role       = aws_iam_role.role_name[0].name
  policy_arn = aws_iam_policy.policy_name[0].arn
}
