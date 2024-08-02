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
  key_name      = "ec2_key"

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y ruby wget
              cd /home/ec2-user
              wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
              chmod +x ./install
              ./install auto
              service codedeploy-agent start
              sudo yum install -y httpd
              sudo systemctl enable --now httpd
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
