resource "aws_codecommit_repository" "this" {
  repository_name = "my-cicd-project"
  description     = "CodeCommit repository for my-cicd-project"
}
