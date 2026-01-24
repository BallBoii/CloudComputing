output "siege_ip" {
    value       = aws_instance.siege_server.public_ip
    description = "Public IP of the Siege server"
}

output "web_ip" {
    value       = aws_instance.web_server.public_ip
    description = "Public IP of the Web server"
}

output "sql_ip" {
    value       = aws_instance.sql_server.public_ip
    description = "Public IP of the SQL server"
}  
