provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_codecommit_repository" "Terrafrom-Project" {
  repository_name = "airline-booking-repo"
  description     = "Terrafrom-Project for airline-booking application"
}
