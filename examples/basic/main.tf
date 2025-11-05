module "file" {
  source = "../../"

  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = var.datastore_id

  source_raw = {
    file_name = "test-snippet.yaml"
    data      = <<-EOT
      #cloud-config
      users:
        - name: terratest
          ssh_authorized_keys:
            - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... (test key)
          sudo: ALL=(ALL) NOPASSWD:ALL
          groups: sudo
          shell: /bin/bash
      package_update: true
      packages:
        - qemu-guest-agent
        - curl
    EOT
  }
}

output "file" {
  value = {
    test_snippet = module.file.file
  }
}

