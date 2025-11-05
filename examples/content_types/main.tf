module "snippet_file" {
  source = "../../"

  node_name    = var.node_name
  content_type = "snippets"
  datastore_id = var.datastore_id

  source_raw = {
    file_name = "test-snippet.yaml"
    data      = <<-EOT
      #cloud-config
      hostname: test-vm
    EOT
  }
}

output "file" {
  value = {
    snippet = module.snippet_file.file
  }
}

