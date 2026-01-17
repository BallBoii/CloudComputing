#!/bin/bash
# Quick deployment commands for Ansible

# Get script directory and cd to it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Working directory: $(pwd)"
echo ""

# Load environment variables from .env file
if [ -f .env ]; then
    echo "Loading environment from .env file..."
    set -a  # automatically export all variables
    source .env
    set +a
    echo "✓ Environment loaded"
else
    echo "WARNING: .env file not found!"
    echo "Please create .env file from .env.example:"
    echo "  cp .env.example .env"
    echo "  # Edit .env with your credentials"
    exit 1
fi

# Verify credentials
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "ERROR: AWS credentials not set in .env file!"
    echo "Please edit .env file and add your credentials."
    exit 1
fi

echo "AWS credentials loaded (Key: ${AWS_ACCESS_KEY_ID:0:10}...)"
echo ""

# Check if boto3 is installed
echo "Checking boto3 installation..."
python3 -c "import boto3; print(f'boto3 version: {boto3.__version__}')" || {
    echo "ERROR: boto3 not installed. Run: pip3 install boto3 botocore"
    exit 1
}
echo ""

echo "Testing inventory..."
ansible-inventory -i aws_ec2.yml --graph

echo ""
echo "Listing all hosts..."
ansible-inventory -i aws_ec2.yml --list | head -50

echo ""
echo "Testing connectivity..."
ansible all -i aws_ec2.yml -m ping

echo ""
echo "Deploying all servers..."
ansible-playbook playbooks/site.yml -v

echo ""
echo "Deployment completed!"
