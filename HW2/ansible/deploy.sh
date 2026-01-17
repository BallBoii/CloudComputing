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
