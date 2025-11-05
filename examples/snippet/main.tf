module "file" {
  source = "../../"

  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = var.datastore_id

  source_raw = {
    file_name = "cloud-init-user.yaml"
    data      = <<-EOT
      #cloud-config
      hostname: terratest-vm
      manage_etc_hosts: true
      users:
        - name: admin
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh_authorized_keys:
            - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDtest... (test key)
      
      packages:
        - qemu-guest-agent
        - vim
        - htop
        - curl
        - wget
      
      runcmd:
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - echo "Cloud-init completed" > /root/cloud-init-status.txt
      
      power_state:
        mode: reboot
        message: Rebooting after cloud-init
        timeout: 30
        condition: True
    EOT
  }
}

output "file" {
  value = {
    cloud_init = module.file.file
  }
}

