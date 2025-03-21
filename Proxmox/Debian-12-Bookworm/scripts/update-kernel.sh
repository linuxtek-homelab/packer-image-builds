#!/bin/bash

echo 'deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware' | sudo tee /etc/apt/sources.list.d/backports.list
sudo apt-get update
sudo apt-get install -y -t bookworm-backports linux-image-amd64 linux-headers-amd64
sudo update-grub
sudo reboot