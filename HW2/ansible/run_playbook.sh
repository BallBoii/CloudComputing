#!/bin/bash
# Professional playbook execution script

set -e

PLAYBOOK="${1:-site.yml}"
INVENTORY="${2:-inventories/production/hosts.ini}"

echo "=================================="
echo "Ansible Playbook Execution"
echo "=================================="
echo "Playbook: $PLAYBOOK"
echo "Inventory: $INVENTORY"
echo "=================================="

# Run syntax check
echo "Running syntax check..."
ansible-playbook "$PLAYBOOK" -i "$INVENTORY" --syntax-check

# Show what will be affected
echo "Hosts that will be affected:"
ansible-playbook "$PLAYBOOK" -i "$INVENTORY" --list-hosts

# Ask for confirmation
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborted."
    exit 1
fi

# Execute playbook
echo "Executing playbook..."
ansible-playbook "$PLAYBOOK" -i "$INVENTORY"

echo "=================================="
echo "Playbook execution completed!"
echo "=================================="
