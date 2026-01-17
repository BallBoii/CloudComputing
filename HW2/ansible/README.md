# Ansible Server Deployment Guide

## Initial Setup on Ansible Server

### 1. Configure .env file locally
```bash
# Copy the example file
cp .env.example .env

# Edit with your credentials
nano .env
```

Add your AWS credentials:
```env
AWS_ACCESS_KEY_ID=your-access-key-here
AWS_SECRET_ACCESS_KEY=your-secret-key-here
AWS_DEFAULT_REGION=us-east-1
ANSIBLE_SSH_PRIVATE_KEY=~/.ssh/ansibleSSH.pem
```

### 2. Copy project files to Ansible Server
```bash
# From your local machine
scp -i ~/.ssh/ansibleSSH.pem -r ./ansible ec2-user@<ANSIBLE_SERVER_IP>:~/
```

### 3. SSH into Ansible Server
```bash
ssh -i ~/.ssh/ansibleSSH.pem ec2-user@<ANSIBLE_SERVER_IP>
```

### 4. Run the deployment setup script
```bash
cd ~/ansible
chmod +x deploy.sh
./deploy.sh
```

The script will:
- Install Python3 and pip
- Install Ansible
- Install AWS collections (amazon.aws, community.mysql)
- Install boto3 for AWS dynamic inventory
- Configure AWS credentials
- Setup SSH keys

### 4. Verify inventory
```bash
ansible-inventory -i aws_ec2.yml --graph
ansible-inventory -i aws_ec2.yml --list
```

### 5. Test connectivity
```bash
ansible all -i aws_ec2.yml -m ping
```

## Running Playbooks

### Deploy all servers
```bash
ansible-playbook playbooks/site.yml
```

### Deploy individual servers
```bash
# Siege server
ansible-playbook playbooks/siege.yml

# Web server
ansible-playbook playbooks/webserver.yml

# SQL server
ansible-playbook playbooks/sqlserver.yml
```

### Run with verbose output
```bash
ansible-playbook playbooks/site.yml -v   # verbose
ansible-playbook playbooks/site.yml -vv  # more verbose
ansible-playbook playbooks/site.yml -vvv # very verbose
```

### Check mode (dry run)
```bash
ansible-playbook playbooks/site.yml --check
```

## Quick Deploy Script

For subsequent deployments, use the quick deploy script:
```bash
chmod +x run_playbooks.sh
./run_playbooks.sh
```

## Troubleshooting

### Check AWS credentials
```bash
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
```

### Verify SSH key permissions
```bash
chmod 400 ~/.ssh/ansibleSSH.pem
```

### Test specific host
```bash
ansible siege -i aws_ec2.yml -m ping
ansible web -i aws_ec2.yml -m ping
ansible sql -i aws_ec2.yml -m ping
```

### View hosts in inventory
```bash
ansible siege --list-hosts
ansible web --list-hosts
ansible sql --list-hosts
```
