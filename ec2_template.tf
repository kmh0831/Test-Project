resource "aws_iam_instance_profile" "code_deploy_instance_profile" {
  name = "my-cicd-project-code-deploy-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_launch_template" "code_deploy_template" {
  name = "my-cicd-project-launch-template"

  iam_instance_profile {
    name = aws_iam_instance_profile.code_deploy_instance_profile.name
  }

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name  # 여기에 올바른 키 쌍 이름을 사용하세요

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y ruby wget
              cd /home/ec2-user
              wget https://aws-codedeploy-${data.aws_region.current.name}.s3.${data.aws_region.current.name}.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              service codedeploy-agent start
              sudo yum install -y httpd
              sudo systemctl enable --now httpd
              curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
	            sudo yum install -y nodejs
              sudo yum install -y git
              EOF
  )
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_region" "current" {}
