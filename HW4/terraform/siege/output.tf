output "siege_ip" {
    value       = aws_instance.siege_server.public_ip
    description = "Public IP of the Siege server"
}