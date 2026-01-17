# Ansible Infrastructure Configuration

## Overview
This directory contains a professionally structured Ansible project for managing infrastructure across multiple server types: web servers, SQL servers, and load testing servers.

## Directory Structure

```
ansible/
├── ansible.cfg                 # Ansible configuration
├── site.yml                    # Main playbook (entry point)
├── inventories/                # Inventory management
│   └── production/
│       └── hosts.ini          # Production hosts
├── group_vars/                 # Group-level variables
│   └── all.yml                # Variables for all hosts
├── roles/                      # Reusable roles
│   ├── webserver/             # Web server role
│   │   ├── tasks/
│   │   │   └── main.yml       # Web server tasks
│   │   ├── handlers/
│   │   │   └── main.yml       # Apache restart handler
│   │   └── files/
│   │       ├── index.php      # Application files
│   │       └── styles.css
│   ├── sqlserver/             # SQL server role
│   │   ├── tasks/
│   │   │   └── main.yml       # MariaDB setup tasks
│   │   └── defaults/
│   │       └── main.yml       # Default variables
│   └── siege/                 # Load testing server role
│       └── tasks/
│           └── main.yml       # Siege installation tasks
└── playbooks/                 # Legacy playbooks (deprecated)
```

## Professional Best Practices Implemented

### 1. **Role-Based Architecture**
   - Each server type has its own role with clear responsibilities
   - Roles are reusable across different projects
   - Tasks, handlers, files, and variables are separated by concern

### 2. **Inventory Management**
   - Inventories are organized by environment (production)
   - Easy to add staging, development, or other environments
   - Variables are separated from inventory files

### 3. **Variable Hierarchy**
   - `group_vars/all.yml` - Variables for all hosts
   - `roles/*/defaults/main.yml` - Default role variables
   - Can add `host_vars/` for host-specific overrides

### 4. **File Organization**
   - Application files are stored in role-specific `files/` directories
   - Handlers are separated from tasks
   - Configuration is centralized in ansible.cfg

## Usage

### Run the Complete Deployment
```bash
cd ansible
ansible-playbook site.yml
```

### Run Individual Roles
```bash
# Configure only web servers
ansible-playbook site.yml --tags webserver

# Configure only SQL servers
ansible-playbook site.yml --tags sqlserver

# Configure only siege servers
ansible-playbook site.yml --tags siege
```

### Dry Run (Check Mode)
```bash
ansible-playbook site.yml --check
```

### Verbose Output
```bash
ansible-playbook site.yml -v    # Basic verbose
ansible-playbook site.yml -vv   # More verbose
ansible-playbook site.yml -vvv  # Very verbose (debug)
```

## Configuration

### Ansible Configuration (ansible.cfg)
- Default inventory points to `inventories/production/hosts.ini`
- SSH settings configured for EC2 instances
- Roles path set to `./roles`

### Inventory (inventories/production/hosts.ini)
Update IP addresses as needed:
```ini
[siege]
<siege-server-ip>

[web]
<web-server-ip>

[sql]
<sql-server-ip>
```

### Variables (group_vars/all.yml)
Common variables affecting all hosts:
- SSH user
- Connection parameters

### Role Variables (roles/*/defaults/main.yml)
Each role has its own default variables that can be overridden.

## Security Considerations

### Sensitive Data
The MariaDB root password should be managed using Ansible Vault:

```bash
# Create vault file
ansible-vault create group_vars/all/vault.yml

# Add encrypted variables
vault_mariadb_root_password: "your-secure-password"

# Reference in roles/sqlserver/defaults/main.yml
mariadb_root_password: "{{ vault_mariadb_root_password }}"

# Run with vault
ansible-playbook site.yml --ask-vault-pass
```

### SSH Keys
Ensure your SSH private key is properly configured in `ansible.cfg`:
```ini
private_key_file = ~/.ssh/your-key.pem
```

## Adding New Roles

To add a new role:

```bash
# Create role structure
ansible-galaxy init roles/newrole

# Or manually create directories
mkdir -p roles/newrole/{tasks,handlers,files,templates,vars,defaults}
```

## Troubleshooting

### Connection Issues
```bash
# Test connectivity
ansible all -m ping

# Check inventory
ansible-inventory --list
ansible-inventory --graph
```

### Role Issues
```bash
# Syntax check
ansible-playbook site.yml --syntax-check

# List all tasks
ansible-playbook site.yml --list-tasks

# List all hosts
ansible-playbook site.yml --list-hosts
```

## Migration from Old Structure

The old `playbooks/` directory has been replaced with the role-based approach:
- `playbooks/webserver.yml` → `roles/webserver/`
- `playbooks/sqlserver.yml` → `roles/sqlserver/`
- `playbooks/siege.yml` → `roles/siege/`
- `playbooks/site.yml` → `site.yml` (refactored)

Old playbooks can be removed once the new structure is tested and verified.

## Benefits of This Structure

1. **Scalability**: Easy to add new roles and environments
2. **Reusability**: Roles can be shared across projects
3. **Maintainability**: Clear separation of concerns
4. **Testing**: Can test individual roles in isolation
5. **Collaboration**: Standard structure familiar to Ansible professionals
6. **Version Control**: Better Git history with organized file structure

## Next Steps

1. Test the new structure with `ansible-playbook site.yml --check`
2. Set up Ansible Vault for sensitive data
3. Add staging/development inventories as needed
4. Consider adding tags to tasks for more granular control
5. Add molecule tests for role validation
6. Remove old `playbooks/` directory after verification
