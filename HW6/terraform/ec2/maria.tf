# EC2 instance for MariaDB setup
resource "aws_instance" "maria" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name      = var.key_pair
    subnet_id     = var.private_subnet
    vpc_security_group_ids = [data.aws_security_group.maria_sg.id]
    
    user_data = <<-EOF
        #!/bin/bash
        # Update system packages
        dnf update -y
        
        # Install MariaDB server
        dnf install -y mariadb105-server python3-pip
        
        # Install PyMySQL for database operations
        pip3 install PyMySQL
        
        # Start and enable MariaDB service
        systemctl start mariadb
        systemctl enable mariadb
        
        # Set MariaDB root password
        mysqladmin -u root password 'strongpassword'
        
        # Create database
        mysql -u root -pstrongpassword -e "CREATE DATABASE IF NOT EXISTS ebdb;"
        
        # Grant remote access to root user
        mysql -u root -pstrongpassword -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'strongpassword';"
        mysql -u root -pstrongpassword -e "GRANT ALL PRIVILEGES ON ebdb.* TO 'root'@'%';"
        mysql -u root -pstrongpassword -e "FLUSH PRIVILEGES;"
        
        # Configure MariaDB to listen on all interfaces
        echo "[mysqld]" >> /etc/my.cnf.d/server.cnf
        echo "bind-address = 0.0.0.0" >> /etc/my.cnf.d/server.cnf
        
        # Restart MariaDB to apply changes
        systemctl restart mariadb
    EOF
    
    tags = {
        Name = "MariaDB-Server"
    }
}

# Get Security Group for MariaDB
data "aws_security_group" "maria_sg" {
  filter {
    name   = "group-name"
    values = ["${var.name_prefix}-db-sg"]
  }
}
