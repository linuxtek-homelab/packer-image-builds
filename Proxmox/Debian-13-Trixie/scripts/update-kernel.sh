#!/bin/bash
echo "debconf debconf/frontend select Noninteractive" | sudo debconf-set-selections

# This is currently stored in /etc/apt/sources.list and not needed in new format yet.

# sudo tee /etc/apt/sources.list.d/debian-trixie.sources > /dev/null <<'EOF'
# Types: deb
# URIs: http://deb.debian.org/debian
# Suites: trixie
# Components: main contrib non-free non-free-firmware
# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# Types: deb
# URIs: http://security.debian.org/debian-security
# Suites: trixie-security
# Components: main contrib non-free non-free-firmware
# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
# EOF

sudo apt update
sudo apt full-upgrade -y
sudo apt install -y linux-image-amd64 linux-headers-amd64
sudo reboot
