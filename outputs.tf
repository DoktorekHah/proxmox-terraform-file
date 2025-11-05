output "file" {
  description = "The file resource information including the unique identifier and file name"
  value = {
    id        = proxmox_virtual_environment_file.this.id
    file_name = proxmox_virtual_environment_file.this.file_name
  }
}
