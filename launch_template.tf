resource "aws_iam_instance_profile" "example_launch" {
  count = data.aws_iam_instance_profile.existing_codedeploy_instance_profile.name != "" ? 0 : 1

  name = "example_instance_profile"
  role = aws_iam_role.codepipeline_role[count.index].name
}

resource "aws_launch_template" "example" {
  name = "example-launch-template"

  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.example_launch[count.index].name
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
