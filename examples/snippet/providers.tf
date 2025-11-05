terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.63.3"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = var.proxmox_insecure
}

variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox VE API endpoint"
  default     = "https://192.168.1.100:8006"
}

variable "proxmox_insecure" {
  type        = bool
  description = "Whether to skip TLS verification"
  default     = true
}

