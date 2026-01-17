#!/bin/bash
# Deployment script for Ansible server

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "================================================"
echo "Ansible Server Setup and Deployment Script"
echo "================================================"

# Step 1: Install required packages
echo ""
echo "[1/6] Installing Python3 and pip..."
sudo dnf install -y python3 python3-pip git

# Step 2: Install Ansible
echo ""
echo "[2/6] Installing Ansible..."
sudo pip3 install ansible

# Step 3: Install AWS collections and dependencies
echo ""
echo "[3/6] Installing AWS collections and boto3..."
pip3 install --user boto3 botocore
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.mysql

# Step 4: Configure environment file
echo ""
echo "[4/6] Configuring .env file..."
if [ ! -f .env ]; then
    echo ".env file not found. Let's create it."
    echo ""
    echo "Please enter your AWS credentials:"
    read -p "AWS Access Key ID: " AWS_KEY
    read -sp "AWS Secret Access Key: " AWS_SECRET
    echo ""
    read -p "AWS Region [us-east-1]: " AWS_REGION
    AWS_REGION=${AWS_REGION:-us-east-1}
    
    # Create .env file
    cat > .env << EOF
# AWS Credentials
AWS_ACCESS_KEY_ID=$AWS_KEY
AWS_SECRET_ACCESS_KEY=$AWS_SECRET

# AWS Region
AWS_DEFAULT_REGION=$AWS_REGION

# SSH Key Path
ANSIBLE_SSH_PRIVATE_KEY=~/.ssh/ansibleSSH.pem

# Ansible Configuration
ANSIBLE_HOST_KEY_CHECKING=False
EOF
    
    chmod 600 .env
    echo ".env file created successfully!"
else
    echo ".env file already exists. Using existing configuration."
fi

# Load environment variables
source .env
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION

# Step 5: Setup SSH key
echo ""
echo "[5/6] Setting up SSH key..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Copy your private key to ~/.ssh/ansibleSSH.pem
echo "Please copy your private key file to ~/.ssh/ansibleSSH.pem"
echo "You can use: scp -i your-key.pem your-key.pem ec2-user@ansible-server-ip:~/.ssh/ansibleSSH.pem"
read -p "Press Enter when the key file is in place..."

chmod 400 ~/.ssh/ansibleSSH.pem

# Step 6: Test dynamic inventory
echo ""
echo "[6/6] Testing dynamic inventory..."
ansible-inventory -i aws_ec2.yml --graph

echo ""
echo "================================================"
echo "Setup Complete! Ready to deploy."
echo "================================================"
echo ""
echo "Available commands:"
echo "  # Test inventory:"
echo "  ansible-inventory -i aws_ec2.yml --list"
echo ""
echo "  # Test connectivity:"
echo "  ansible all -i aws_ec2.yml -m ping"
echo ""
echo "  # Deploy all servers:"
echo "  ansible-playbook playbooks/site.yml"
echo ""
echo "  # Deploy specific server:"
echo "  ansible-playbook playbooks/siege.yml"
echo "  ansible-playbook playbooks/webserver.yml"
echo "  ansible-playbook playbooks/sqlserver.yml"
echo ""
