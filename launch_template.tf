resource "aws_launch_template" "example" {
  name = "example-launch-template"

  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name # 실제 키 페어 이름으로 변경해야 합니다.

  iam_instance_profile {
    name = aws_iam_instance_profile.example[0].name
  }

  user_data = <<-EOF
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

  tags = {
    Name = "example-instance"
  }
}

# 데이터 소스: 기존 IAM 인스턴스 프로필 확인
data "aws_iam_instance_profile" "existing_codedeploy_instance_profile" {
  name = "codedeploy_instance_profile"
}

# IAM 인스턴스 프로필이 존재하지 않는 경우에만 새로 생성
resource "aws_iam_instance_profile" "example_launch" {
  count = data.aws_iam_instance_profile.existing_codedeploy_instance_profile.name != "" ? 0 : 1

  name = "example_instance_profile"
  role = aws_iam_role.example.name
}

