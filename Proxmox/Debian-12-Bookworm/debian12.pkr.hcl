packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "debian" {
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  username                 = var.proxmox_api_user
  token                    = var.proxmox_api_token
  insecure_skip_tls_verify = true

  template_description = "Built from ${basename(var.iso_file)} on ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  node                 = var.proxmox_node

  network_adapters {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
    vlan_tag = var.network_vlan
  }

  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    io_thread    = true
    storage_pool = var.storage_pool
    type         = "scsi"
  }

  scsi_controller = "virtio-scsi-single"

  http_directory = "./"
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]

  boot_iso {
    type     = "scsi"
    iso_file = var.iso_file
    unmount  = true
  }

  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool

  vm_name  = trimsuffix(basename(var.iso_file), ".iso")
  cpu_type = var.cpu_type
  os       = "l26"
  memory   = var.memory
  cores    = var.cores
  sockets  = "1"
  machine  = var.machine_type

  # Note: this password is needed by packer to run the file provisioner, but
  # once that is done - the password will be set to random one by cloud init.
  ssh_password = "packer"
  ssh_username = "root"
  ssh_timeout  = "30m"
}

build {
  sources = ["source.proxmox-iso.debian"]

  # Install Backports and upgrade to latest 6.x kernel
  provisioner "shell" {
    script = "scripts/update-kernel.sh"
    pause_before = "10s"
  }

  # Install key packages, prerequisites, and Docker
  provisioner "shell" {
    script = "scripts/install-docker.sh"
    pause_before = "10s"
  }

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "cloud.cfg"
  }
}