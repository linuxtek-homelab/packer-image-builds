variable "iso_file" {
  type = string
}

variable "cloud_init_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "32G"
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "memory" {
  type    = string
  default = "8196"
}

variable "network_vlan" {
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}