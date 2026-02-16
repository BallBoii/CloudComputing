# EC2 instance for WordPress setup
resource "aws_instance" "wordpress" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name      = var.key_pair
    subnet_id     = var.public_subnet
    vpc_security_group_ids = [data.aws_security_group.wordpress_sg.id]
    
    tags = {
        Name = "WordPress-Server"
    }
}

# Get Security Group for WordPress
data "aws_security_group" "wordpress_sg" {
  filter {
    name   = "group-name"
    values = ["${var.name_prefix}-wordpress-sg"]
  }
}

