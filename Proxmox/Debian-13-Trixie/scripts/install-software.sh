#!/bin/bash

# Continue Software Configuration
echo 'Reconnected after reboot, finalizing image setup...'
echo "debconf debconf/frontend select Noninteractive" | sudo debconf-set-selections
sudo apt update

# Install Software
sudo apt install -y ca-certificates cloud-init curl git gpg gnupg htop lsb-release openssl openssh-server python3 qemu-guest-agent vim 
sudo apt install -y python3 python3-venv python3-dev python3-pip

# Enable Services
sudo systemctl start qemu-guest-agent
sudo systemctl enable --now ssh

# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get autoremove -y
sudo apt-get clean