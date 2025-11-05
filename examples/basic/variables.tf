variable "node_name" {
  type        = string
  description = "The name of the Proxmox node"
  default     = "pve"
}

variable "datastore_id" {
  type        = string
  description = "The datastore ID where the file will be stored"
  default     = "local"
}

