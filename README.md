# Proxmox File Terraform Module

A comprehensive Terraform/OpenTofu module for managing Proxmox VE files with integrated security scanning (Checkov) and code linting (TFLint). This module supports both Terraform and OpenTofu through a unified Makefile.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6.0-623CE4)](https://www.terraform.io/)
[![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.0-FFDA18)](https://opentofu.org/)
[![Go](https://img.shields.io/badge/Go-%3E%3D1.19-00ADD8)](https://golang.org/)
[![Python](https://img.shields.io/badge/Python-%3E%3D3.8-3776AB)](https://www.python.org/)
[![Checkov](https://img.shields.io/badge/Checkov-Security-6B4FBB)](https://www.checkov.io/)
[![TFLint](https://img.shields.io/badge/TFLint-Linting-5C4EE5)](https://github.com/terraform-linters/tflint)
[![Terratest](https://img.shields.io/badge/Terratest-Testing-00ADD8)](https://terratest.gruntwork.io/)

## 📋 Table of Contents

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [Makefile Commands](#-makefile-commands)
- [Security & Linting](#-security--linting)
- [Testing](#-testing)
- [Module Reference](#-module-reference)
- [Development](#-development)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### Core Capabilities
- **Dual Tool Support**: Works with both Terraform and OpenTofu
- **File Management**: Complete file lifecycle management on Proxmox VE
- **Multiple Content Types**: Support for ISO, snippets, VZDump backups, and container templates
- **Flexible Upload**: Upload files from local filesystem or provide raw data
- **Checksum Verification**: Optional checksum validation for file integrity
- **TLS Configuration**: Configurable TLS settings for secure file transfers

### Security & Quality
- **Security Scanning**: Integrated Checkov for IaC security analysis
- **Code Linting**: TFLint for Terraform/OpenTofu code quality
- **CI/CD Ready**: Pre-configured pipelines for both Terraform and OpenTofu
- **Best Practices**: Follows Terraform/OpenTofu module best practices

### Advanced Features
- **Dynamic Source Selection**: Automatically handles source_file or source_raw based on configuration
- **Configurable Timeouts**: Control upload timeout for large files
- **File Mode Support**: Set custom file permissions
- **Datastore Management**: Target specific datastores for file uploads

## 🔧 Prerequisites

### Required Tools
- **Terraform** >= 1.6.0 OR **OpenTofu** >= 1.0
- **Python** >= 3.8 (for Checkov security scanning)
- **TFLint** (automatically installed via Makefile)
- **Proxmox VE** cluster with API access

### Optional Tools
- **Go** >= 1.19 (for Terratest integration tests)
- **Terratest** - Go library for automated infrastructure testing
- **pipx** or **pip3** (for Checkov installation)

### Provider Requirements
- `bpg/proxmox` >= 0.63.3

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install all dependencies (Checkov + TFLint)
make install

# Or install individually
make checkov-install
make tflint-install
```

### 2. Initialize TFLint

```bash
# Initialize TFLint plugins (required once)
make tflint-init
```

### 3. Choose Your Tool

#### Using Terraform:
```bash
# Initialize Terraform
make terraform-init

# Validate configuration
make terraform-validate

# Preview changes
make terraform-plan

# Apply changes
make terraform-apply
```

#### Using OpenTofu:
```bash
# Initialize OpenTofu
make tofu-init

# Validate configuration
make tofu-validate

# Preview changes
make tofu-plan

# Apply changes
make tofu-apply
```

### 4. Run Security & Quality Checks

```bash
# Run CI pipeline (recommended)
make ci-terraform    # For Terraform
make ci-tofu         # For OpenTofu

# Or run individually
make checkov-scan    # Security scan
make tflint-check    # Code linting
```

## 💻 Usage

### Upload ISO File from URL

```hcl
module "ubuntu_iso" {
  source = "github.com/your-org/proxmox-terraform-file"

  node_name      = "pve-node1"
  content_type   = "iso"
  datastore_id   = "local"
  path           = "https://releases.ubuntu.com/22.04/ubuntu-22.04.3-live-server-amd64.iso"
  file_name      = "ubuntu-22.04.3-live-server-amd64.iso"
  checksum       = "a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
  upload_timeout = 3600
}

output "iso_id" {
  value = module.ubuntu_iso.file
}
```

### Upload Snippet with Raw Data

```hcl
module "cloud_init_snippet" {
  source = "github.com/your-org/proxmox-terraform-file"

  node_name    = "pve-node1"
  content_type = "snippets"
  datastore_id = "local"
  file_name    = "user-config.yaml"
  data         = <<-EOT
    #cloud-config
    users:
      - name: admin
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2E...
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: sudo
        shell: /bin/bash
    package_update: true
    package_upgrade: true
    packages:
      - qemu-guest-agent
      - curl
      - vim
  EOT
}
```

### Upload Container Template

```hcl
module "container_template" {
  source = "github.com/your-org/proxmox-terraform-file"

  node_name      = "pve-node1"
  content_type   = "vztmpl"
  datastore_id   = "local"
  path           = "https://download.proxmox.com/images/system/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  file_name      = "ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  upload_timeout = 1800
}
```

### Upload with Custom TLS Settings

```hcl
module "secure_iso" {
  source = "github.com/your-org/proxmox-terraform-file"

  node_name    = "pve-node1"
  content_type = "iso"
  datastore_id = "local"
  path         = "https://internal-server.example.com/custom.iso"
  file_name    = "custom.iso"
  insecure     = "false"
}
```

### Multiple File Uploads

```hcl
module "proxmox_files" {
  source = "github.com/your-org/proxmox-terraform-file"
  count  = length(var.files)

  node_name      = var.files[count.index].node_name
  content_type   = var.files[count.index].content_type
  datastore_id   = var.files[count.index].datastore_id
  path           = var.files[count.index].path
  file_name      = var.files[count.index].file_name
  checksum       = lookup(var.files[count.index], "checksum", null)
  upload_timeout = lookup(var.files[count.index], "timeout", 1800)
}

# variables.tf
variable "files" {
  type = list(object({
    node_name    = string
    content_type = string
    datastore_id = string
    path         = string
    file_name    = string
    checksum     = optional(string)
    timeout      = optional(number)
  }))
  default = [
    {
      node_name    = "pve-node1"
      content_type = "iso"
      datastore_id = "local"
      path         = "https://releases.ubuntu.com/22.04/ubuntu-22.04.3-live-server-amd64.iso"
      file_name    = "ubuntu-22.04.3.iso"
      checksum     = "a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
      timeout      = 3600
    },
    {
      node_name    = "pve-node1"
      content_type = "iso"
      datastore_id = "local"
      path         = "https://releases.debian.org/12/amd64/iso-cd/debian-12.2.0-amd64-netinst.iso"
      file_name    = "debian-12.2.0-amd64-netinst.iso"
      timeout      = 2400
    }
  ]
}
```

### Upload Backup Dump

```hcl
module "vm_backup" {
  source = "github.com/your-org/proxmox-terraform-file"

  node_name      = "pve-node1"
  content_type   = "dump"
  datastore_id   = "backup-storage"
  path           = "/local/path/to/vzdump-qemu-100-2024_01_15-12_00_00.vma.zst"
  file_name      = "vzdump-qemu-100-2024_01_15-12_00_00.vma.zst"
  upload_timeout = 7200
}
```

### Resize Cloud Image

```hcl
module "cloud_image" {
  source = "github.com/your-org/proxmox-terraform-file"

  node_name    = "pve-node1"
  content_type = "iso"
  datastore_id = "local"
  data         = filebase64("/path/to/cloud-image.qcow2")
  file_name    = "cloud-image.qcow2"
  resize       = "32G"
}
```

## 📋 Makefile Commands

### Installation & Setup

```bash
make install              # Install all dependencies (Checkov + TFLint)
make checkov-install      # Install Checkov security scanner
make tflint-install       # Install TFLint linter
make tflint-init          # Initialize TFLint plugins
make dev-setup            # Set up complete development environment
```

### Security Scanning (Checkov)

```bash
make checkov-scan         # Run Checkov security scan
make checkov-scan-json    # Run scan with JSON output
make checkov-scan-sarif   # Run scan with SARIF output (CI/CD)
make test-security        # Run security tests only
```

### Code Linting (TFLint)

```bash
make tflint-init          # Initialize TFLint plugins
make tflint-check         # Run TFLint code quality checks
make test-lint            # Run linting tests only
```

### Terraform Commands

```bash
make terraform-init       # Initialize Terraform
make terraform-validate   # Validate Terraform configuration
make terraform-plan       # Create execution plan
make terraform-plan-out   # Create and save execution plan
make terraform-apply      # Apply configuration
make terraform-apply-plan # Apply saved plan
make terraform-destroy    # Destroy infrastructure
make terraform-format     # Format Terraform files
```

### OpenTofu Commands

```bash
make tofu-init            # Initialize OpenTofu
make tofu-validate        # Validate OpenTofu configuration
make tofu-plan            # Create execution plan
make tofu-plan-out        # Create and save execution plan
make tofu-apply           # Apply configuration
make tofu-apply-plan      # Apply saved plan
make tofu-destroy         # Destroy infrastructure
make tofu-format          # Format OpenTofu files
```

### Testing Commands

```bash
make test-terraform-security  # Run Terraform security tests
make test-tofu-security       # Run OpenTofu security tests
make test-terratest           # Run all Terratest tests
make test-basic               # Run basic file upload test
make test-multiple            # Run multiple files test
make test-plan                # Run plan-only test
make test-validate            # Run validation test
```

### CI/CD Commands

```bash
make ci-terraform         # CI pipeline for Terraform (init + validate + lint + security)
make ci-terraform-apply   # CI pipeline for Terraform with apply
make ci-tofu              # CI pipeline for OpenTofu (init + validate + lint + security)
make ci-tofu-apply        # CI pipeline for OpenTofu with apply
```

### Utility Commands

```bash
make clean                # Clean up generated files
make clean-all            # Clean up all files including state
make help                 # Show all available commands
make docs                 # Display module documentation
```

## 🔒 Security & Linting

### Checkov Security Scanning

This module includes integrated security scanning using [Checkov](https://www.checkov.io/) to ensure your infrastructure code follows security best practices.

**Key Features:**
- 🛡️ Security misconfiguration detection
- ✅ Compliance framework validation
- 📊 Multiple output formats (CLI, JSON, SARIF)
- 🔌 CI/CD integration ready
- 📝 Custom policy support

**Configuration:** `.checkov.yml`

```yaml
framework:
  - terraform

output:
  - cli
  - json
  - sarif

skip-download: true
```

**Usage:**
```bash
# Run security scan
make checkov-scan

# Generate JSON report
make checkov-scan-json

# Generate SARIF report for CI/CD
make checkov-scan-sarif
```

### TFLint Code Quality

TFLint checks your Terraform/OpenTofu code for errors, deprecated syntax, and best practices.

**Key Features:**
- 🔍 Syntax and logic error detection
- 📏 Best practice enforcement
- 🎯 Provider-specific rule sets
- 🔄 Naming convention validation
- 📚 Module version checking

**Configuration:** `.tflint.hcl`

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_naming_convention" {
  enabled = true
}
```

**Usage:**
```bash
# Initialize TFLint (once)
make tflint-init

# Run code quality checks
make tflint-check
```

### Security Best Practices

1. **Always scan before deploy:**
   ```bash
   make checkov-scan && make tflint-check
   ```

2. **Review scan results:**
   - Address all **Failed** checks
   - Understand **Skipped** checks
   - Document exceptions

3. **Integrate into CI/CD:**
   ```bash
   make ci-terraform  # Runs security + linting + validation for Terraform
   make ci-tofu       # Runs security + linting + validation for OpenTofu
   ```

## 🧪 Testing

### Quick Test Workflows

```bash
# Run complete CI pipeline
make ci-terraform        # For Terraform
make ci-tofu             # For OpenTofu

# Run specific tests
make test-terratest      # Run all Terratest tests
make test-basic          # Test basic file upload
make test-multiple       # Test multiple files
make test-plan           # Test plan generation
make test-validate       # Test validation

# Run security tests
make test-terraform-security
make test-tofu-security
```

### CI/CD Pipeline

The `ci` target runs a complete pipeline suitable for CI/CD:

```bash
make ci-terraform
make ci-terraform-apply
make ci-tofu
make ci-tofu-apply
```

This executes:
1. Terraform/OpenTofu initialization
2. Terraform/OpenTofu validate
3. TFLint initialization
4. TFLint code quality check
5. Checkov security scan
6. Execution plan generation (optional)

### Terratest Integration Tests

Run automated infrastructure tests using Terratest:

```bash
# Run all Terratest tests
make test-terratest

# Run individual test scenarios
make test-basic          # Basic file upload
make test-multiple       # Multiple files with different types
make test-plan           # Plan-only test (no apply)
make test-validate       # Validation test
```

## 📚 Module Reference

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement_proxmox) | >= 0.63.3 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider_proxmox) | >= 0.63.3 |

#### Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_file.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file) | resource |

#### Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_content_type"></a> [content_type](#input_content_type) | The content type to store the file as. Options: dump, iso, snippets, vztmpl | `string` | no |
| <a name="input_datastore_id"></a> [datastore_id](#input_datastore_id) | The identifier for the target datastore | `string` | no |
| <a name="input_file_mode"></a> [file_mode](#input_file_mode) | The file mode when creating a file. Options: overwrite, rename | `string` | no |
| <a name="input_node_name"></a> [node_name](#input_node_name) | The name of the Proxmox node to create the VM on | `string` | yes |
| <a name="input_source_file"></a> [source_file](#input_source_file) | The source file configuration. Contains path (URL or local file path), checksum (in the format '<algorithm>:<checksum>'), file_name, and optional insecure flag (whether to skip TLS verification) | <pre>map(object({<br/>    path      = string<br/>    checksum  = string<br/>    file_name = string<br/>    insecure  = optional(string)<br/>  }))</pre> | no |
| <a name="input_source_raw"></a> [source_raw](#input_source_raw) | The raw source configuration for creating a file directly on the node. Contains data (raw file content), file_name, and optional resize parameter (disk size in format like '32G') | <pre>map(object({<br/>    data      = string<br/>    file_name = string<br/>    resize    = optional(string)<br/>  }))</pre> | no |
| <a name="input_upload_timeout"></a> [upload_timeout](#input_upload_timeout) | The timeout in seconds for the file upload operation | `number` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_file"></a> [file](#output_file) | The file resource information including the unique identifier and file name |
<!-- END_TF_DOCS -->

### Content Types

This module supports the following Proxmox VE content types:

#### ISO Images (`iso`)
- Installation ISOs for operating systems
- Live CD/DVD images
- Rescue system images
- Cloud-init images

#### Container Templates (`vztmpl`)
- LXC container templates
- Pre-configured container images
- Custom container templates

#### VZDump Backups (`dump`)
- VM backup files
- Container backup files
- Compressed backup archives

#### Snippets (`snippets`)
- Cloud-init configuration files
- Hook scripts
- Custom configuration snippets
- User data files

### File Upload Methods

#### Method 1: Upload from URL or Local Path
Use the `path` parameter to specify a URL or local file path:

```hcl
path      = "https://example.com/file.iso"
checksum  = "sha256:..."  # Optional but recommended
file_name = "custom-name.iso"
```

#### Method 2: Upload Raw Data
Use the `data` parameter to provide raw file content:

```hcl
data      = file("/path/to/local/file")
file_name = "file.txt"
resize    = "10G"  # Optional
```

### Debugging

```bash
# Enable Terraform debug logging
export TF_LOG=DEBUG
make terraform-plan

# Enable OpenTofu debug logging
export TF_LOG=DEBUG
make tofu-plan

# Clean up everything and start fresh
make clean-all
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Before Contributing

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow Terraform/OpenTofu best practices
   - Update documentation
   - Add tests if applicable

4. **Run quality checks**
   ```bash
   make terraform-format
   make tflint-check
   ```

5. **Commit with clear messages**
   ```bash
   # For new features
   git commit -m "feat: add new feature"
   
   # For bug fixes
   git commit -m "fix: resolve issue with file upload"
   
   # For documentation updates
   git commit -m "docs: update README examples"
   
   # For refactoring
   git commit -m "refactor: improve code structure"
   ```

6. **Submit a pull request**

### Development Guidelines

- ✅ Always run `make checkov-scan` before committing
- ✅ Ensure all tests pass with `ci-terraform` or `ci-tofu`
- ✅ Follow semantic versioning
- ✅ Update README for new features
- ✅ Add examples for new functionality
- ✅ Document any breaking changes

### Code Style

- Use descriptive variable names
- Add comments for complex logic
- Follow the existing code structure

## 📖 Additional Resources

### Documentation
- [Proxmox Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Proxmox VE File Resource](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_file)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/language/modules/develop)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [Proxmox VE Storage](https://pve.proxmox.com/wiki/Storage)

### Community
- [Proxmox Forum](https://forum.proxmox.com/)
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core)
- [OpenTofu Community](https://opentofu.org/community/)

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

**Made with ❤️ for the Proxmox and Terraform/OpenTofu community**
