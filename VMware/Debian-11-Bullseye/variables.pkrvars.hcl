##################################################################################
# VARIABLES
##################################################################################

# HTTP Settings

http_directory = "http"

# Virtual Machine Settings

vm_guest_os_family      = "linux"
vm_guest_os_vendor      = "debian"
vm_guest_os_member      = "server"
vm_guest_os_version     = "11"
vm_guest_os_type        = "debian11_64Guest"
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

iso_file     = "debian-11.2.0-amd64-DVD-1.iso"
iso_checksum = "022370f066bc91b2cdac3837ff5fa9f3822c5afb2fc34f68084416079fe5a408"

# Scripts

shell_scripts = ["./scripts/setup_debian.sh"]