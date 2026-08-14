resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.ami_id
  instance_type = "t3.small"
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]


  # <-- THÊM: gán IAM instance profile cho EC2
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(file("${path.module}/user-data.sh"))



  #   # Override root volume
  #   block_device_mappings {
  #     device_name = "/dev/xvda"

  #     ebs {
  #       volume_size           = 20
  #       volume_type           = "gp3"
  #       delete_on_termination = true
  #     }
  #   }


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web-Server"
    }
  }
}
