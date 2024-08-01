# codebuild
resource "aws_codebuild_project" "build_project" {
  name         = "airline-booking-build"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type      = "S3"
    location  = aws_s3_bucket.artifact_bucket.bucket
    packaging = "ZIP"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "NODE_ENV"
      value = "production"
    }
  }

  source {
    type      = "CODECOMMIT"
    location  = aws_codecommit_repository.repository.clone_url_http
    buildspec = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 16
    commands:
      - echo Installing dependencies...
      - npm install
  build:
    commands:
      - echo Build started on `date`
      - npm run build
      - echo Creating zip file...
      - cd dist
      - zip -r ../build-artifact.zip .
artifacts:
  files:
    - 'build-artifact.zip'
EOF
  }
}