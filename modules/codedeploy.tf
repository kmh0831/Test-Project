resource "aws_codedeploy_application" "this" {
  name = "my-cicd-project"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_application.this.name
  deployment_group_name = "my-cicd-project-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy.arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                       = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      value = "my-cicd-project-instance"
      type  = "KEY_AND_VALUE"
    }
  }
}
