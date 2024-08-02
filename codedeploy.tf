resource "aws_codedeploy_app" "application" {
  name = "airline-booking-app"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.application.name
  deployment_group_name  = "airline-booking-deployment-group"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    green_fleet_provisioning_option {
      action = "DISCOVER_EXISTING"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE" # 또는 "KEEP_ALIVE"
      termination_wait_time_in_minutes = 5 # (옵션) 블루 인스턴스 종료 대기 시간
    }
  }
}

