##################################################################################
# VARIABLES
##################################################################################

# HTTP Settings

http_directory = "http"

# Virtual Machine Settings

vm_guest_os_family      = "linux"
vm_guest_os_vendor      = "ubuntu"
vm_guest_os_member      = "server"
vm_guest_os_version     = "21-10-lts"
vm_guest_os_type        = "ubuntu64Guest"
vm_version              = 19
vm_firmware             = "bios"
vm_cdrom_type           = "sata"
vm_cpu_sockets          = 4
vm_cpu_cores            = 1
vm_mem_size             = 8192
vm_disk_size            = 100000
vm_disk_controller_type = ["pvscsi"]
vm_network_card         = "vmxnet3"
vm_boot_wait            = "2s"

# ISO Objects

iso_file     = "ubuntu-21.10-live-server-amd64.iso"
iso_checksum = "e84f546dfc6743f24e8b1e15db9cc2d2c698ec57d9adfb852971772d1ce692d4"

# Scripts

shell_scripts = ["./scripts/setup_ubuntu2110.sh"]