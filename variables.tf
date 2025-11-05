variable "node_name" {
  type        = string
  description = "The name of the Proxmox node to create the VM on"
}

variable "content_type" {
  type        = string
  default     = "iso"
  description = "The content type to store the file as. Options: dump, iso, snippets, vztmpl"
  validation {
    condition     = contains(["dump", "iso", "snippets", "vztmpl"], var.content_type)
    error_message = "You must choose from dump, iso, snippets, vztmpl"
  }
}

variable "datastore_id" {
  type        = string
  default     = null
  description = "The identifier for the target datastore"
}

variable "file_mode" {
  type        = string
  default     = null
  description = "The file mode when creating a file. Options: overwrite, rename"
}

variable "upload_timeout" {
  type        = number
  default     = 1800
  description = "The timeout in seconds for the file upload operation"
}

variable "source_file" {
  type = map(object({
    path      = string
    checksum  = string
    file_name = string
    insecure  = optional(string)
  }))
  default     = null
  description = "The source file configuration. Contains path (URL or local file path), checksum (in the format '<algorithm>:<checksum>'), file_name, and optional insecure flag (whether to skip TLS verification)"
}

variable "source_raw" {
  type = map(object({
    data      = string
    file_name = string
    resize    = optional(string)
  }))
  default     = null
  description = "The raw source configuration for creating a file directly on the node. Contains data (raw file content), file_name, and optional resize parameter (disk size in format like '32G')"
}
