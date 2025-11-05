# Proxmox Terraform File Module - Examples

This directory contains example configurations for the Proxmox Terraform File module. These examples demonstrate various use cases and configurations.

## Available Examples

### 1. Basic Example (`basic/`)

A simple example demonstrating basic file upload functionality with a cloud-init snippet.

**Features:**
- Snippet content type
- Raw data upload using heredoc
- Cloud-init user configuration

**Usage:**
```bash
cd basic
terraform init
terraform plan
terraform apply
```

### 2. Snippet Example (`snippet/`)

A comprehensive cloud-init configuration demonstrating advanced snippet usage.

**Features:**
- Complete cloud-init configuration
- User management
- Package installation
- Run commands on boot
- Power state management

**Usage:**
```bash
cd snippet
terraform init
terraform plan
terraform apply
```

### 3. Multiple Files Example (`multiple/`)

Demonstrates uploading multiple files with different configurations.

**Features:**
- Multiple module instances
- Different file types (network-config, user-data, meta-data)
- Cloud-init multi-part configuration

**Usage:**
```bash
cd multiple
terraform init
terraform plan
terraform apply
```

### 4. Content Types Example (`content_types/`)

Tests different content type validations.

**Features:**
- Content type validation
- Snippets content type
- Basic cloud-init configuration

**Usage:**
```bash
cd content_types
terraform init
terraform plan
terraform apply
```

## Prerequisites

1. **Proxmox VE** cluster with API access
2. **Terraform** >= 1.6.0 OR **OpenTofu** >= 1.0
3. **Proxmox API credentials** configured via environment variables:
   ```bash
   export PROXMOX_VE_ENDPOINT="https://your-proxmox-host:8006"
   export PROXMOX_VE_API_TOKEN="root@pam!your-token=your-token-secret"
   # OR
   export PROXMOX_VE_USERNAME="root@pam"
   export PROXMOX_VE_PASSWORD="your-password"
   ```

## Variables

Each example includes a `variables.tf` file with configurable variables. Common variables include:

- `node_name`: The Proxmox node name (default: "pve")
- `datastore_id`: The datastore ID (default: "local")
- `proxmox_endpoint`: Proxmox API endpoint
- `proxmox_insecure`: Skip TLS verification (default: true)

## Running Examples

### With Terraform

```bash
# Navigate to an example directory
cd basic

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply

# Clean up
terraform destroy
```

### With OpenTofu

```bash
# Navigate to an example directory
cd basic

# Initialize OpenTofu
tofu init

# Plan the deployment
tofu plan

# Apply the configuration
tofu apply

# Clean up
tofu destroy
```

## Automated Testing

These examples are used by the Terratest integration tests located in the `../terratest/` directory. To run the tests:

```bash
# From the module root directory
make test-terratest

# Or run specific tests
make test-basic
make test-snippet
make test-multiple
make test-content-types
```

## Customization

You can customize the examples by:

1. Modifying the `variables.tf` file
2. Creating a `terraform.tfvars` file with your values:
   ```hcl
   node_name    = "pve-node1"
   datastore_id = "local"
   ```
3. Using command-line variables:
   ```bash
   terraform apply -var="node_name=pve-node1"
   ```

## Notes

- These examples use `insecure = true` by default for testing purposes. In production, always use proper TLS certificates.
- The examples create files in the Proxmox datastore. Make sure you have sufficient permissions and storage space.
- Cloud-init snippets can be referenced by VMs during creation.

## Support

For issues or questions about these examples, please refer to the main module [README](../README.md) or open an issue in the repository.

