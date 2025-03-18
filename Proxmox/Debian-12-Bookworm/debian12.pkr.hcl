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
    inline = [
      "echo 'deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware' | sudo tee /etc/apt/sources.list.d/backports.list",
      "sudo apt-get update",
      "sudo apt-get install -y -t bookworm-backports linux-image-amd64 linux-headers-amd64",
      "sudo update-grub",
      "sudo reboot"
    ]
  }

  # Install key packages, Docker, and prerequisites  
  provisioner "shell" {
    inline = [
      "echo 'Reconnected after reboot, finalizing image setup...'",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl git gpg htop openssl openssh-server python3",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",      
      "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable'| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo apt-get autoremove -y",
      "sudo apt-get clean"
    ]
  }

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "cloud.cfg"
  }
}