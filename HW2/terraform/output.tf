output "public_ip_1" {
    value =  "Your Ec2 IP is : ${aws_instance.siege_server.public_ip}"
}

output "public_ip_2" {
    value =  "Your Ec2 IP is : ${aws_instance.web_server.public_ip}"
}

output "public_dns_1" {
    value =  "Your Ec2 DNS is : ${aws_instance.siege_server.public_dns}"
}

output "public_ip_3" {
    value =  "Your Ec2 IP is : ${aws_instance.sql_server.public_ip}"
}

output "ansible_ip" {
    value =  "Your Ec2 IP is : ${aws_instance.ansible_server.public_ip}"
}  
