# codecommit
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_codecommit_repository" "airline_booking_repo" {
  repository_name = "airline-booking-repo"
  description     = "Terraform Project for airline-booking application"
}