# Data source for your custom AMI
data "aws_ami" "phpiaasapp" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["phpiaasapp*"]
  }
}

# Launch Template
resource "aws_launch_template" "app_launch_template" {
  name          = "phpiaasapplaunch"
  description   = "Launch template for application instances"
  image_id      = data.aws_ami.phpiaasapp.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.keys.key_name

  vpc_security_group_ids = [aws_security_group.allow_http_ssh_hw3.id]

  # Monitoring
  monitoring {
    enabled = true
  }

  tags = {
    Name = "phpiaasapplaunch"
  }
}