output "wordpress_instance_id" {
  value = aws_instance.wordpress.id
}

output "wordpress_public_ip" {
    value = aws_instance.wordpress.public_ip
}

output "maria_instance_id" {
  value = aws_instance.maria.id
}

output "maria_private_ip" {
    value = aws_instance.maria.private_ip
}