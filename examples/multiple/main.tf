module "snippet1" {
  source = "../../"

  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = var.datastore_id

  source_raw = {
    file_name = "network-config.yaml"
    data      = <<-EOT
      #cloud-config
      network:
        version: 2
        ethernets:
          eth0:
            dhcp4: true
            dhcp6: false
    EOT
  }
}

module "snippet2" {
  source = "../../"

  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = var.datastore_id

  source_raw = {
    file_name = "user-data.yaml"
    data      = <<-EOT
      #cloud-config
      users:
        - name: testuser
          groups: users
          shell: /bin/bash
          ssh_authorized_keys:
            - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtest...
    EOT
  }
}

module "snippet3" {
  source = "../../"

  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = var.datastore_id

  source_raw = {
    file_name = "meta-data.yaml"
    data      = <<-EOT
      instance-id: terratest-vm-001
      local-hostname: terratest-vm
    EOT
  }
}

output "file" {
  value = {
    snippet1 = module.snippet1.file
    snippet2 = module.snippet2.file
    snippet3 = module.snippet3.file
  }
}

