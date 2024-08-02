resource "aws_codecommit_repository" "my_repo" {
  repository_name = "MyDemoRepo"
  description     = "My demonstration repository"
}
