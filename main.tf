resource "proxmox_virtual_environment_file" "this" {
  provider = proxmox

  content_type   = var.content_type
  datastore_id   = var.datastore_id
  node_name      = var.node_name
  timeout_upload = var.upload_timeout
  file_mode      = var.file_mode

  dynamic "source_file" {
    for_each = var.source_file != null ? [1] : []
    content {
      path      = source_file.value.path
      checksum  = source_file.value.checksum
      file_name = source_file.value.file_name
      insecure  = source_file.value.insecure
      min_tls   = local.tls
    }
  }

  dynamic "source_raw" {
    for_each = var.source_raw != null ? [1] : []
    content {
      data      = source_raw.value.data
      file_name = source_raw.value.file_name
      resize    = source_raw.value.resize
    }
  }
}
