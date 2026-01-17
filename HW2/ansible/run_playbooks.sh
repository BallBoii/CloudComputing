#!/bin/bash
# Quick deployment commands for Ansible

# Set environment
cd /home/ec2-user/ansible

# Load AWS credentials
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

echo "Testing inventory..."
ansible-inventory -i aws_ec2.yml --graph

echo ""
echo "Testing connectivity..."
ansible all -i aws_ec2.yml -m ping

echo ""
echo "Deploying all servers..."
ansible-playbook playbooks/site.yml

echo ""
echo "Deployment completed!"
