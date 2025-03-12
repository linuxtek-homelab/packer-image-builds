#!/bin/bash

echo '> Cleaning all audit logs ...'
if [ -f /var/log/audit/audit.log ]; then
cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
cat /dev/null > /var/log/lastlog
fi

# Cleans SSH keys.
echo '> Cleaning SSH keys ...'
rm -f /etc/ssh/ssh_host_*

#Enable SSHD to start on boot
echo '> Enabling sshd on startup ...'
ssh-keygen -A
systemctl enable sshd

#Generate a new SSH key for use with Terraform
echo '> Generating new SSH key for user debian and adding to Authorized Keys ...'
mkdir $HOME/.ssh/
ssh-keygen -t rsa -b 4096 -q -N "" -f $HOME/.ssh/id_rsa -C ""
mkdir /home/debian/.ssh/tmp
mv $HOME/.ssh/id_rsa* /home/debian/.ssh/
cat /home/debian/.ssh/id_rsa.pub >> /home/debian/.ssh/authorized_keys
chown -R debian:debian /home/debian/.ssh
chmod 600 /home/debian/.ssh/authorized_keys
chmod 600 /home/debian/.ssh/id_rsa*

#Enable passwordless sudo for user debian
echo '> Enabling passwordless sudo for user debian ...'
echo 'debian ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/debian
chmod 440 /etc/sudoers.d/debian

# Sets hostname to localhost.
echo '> Setting hostname to localhost ...'
cat /dev/null > /etc/hostname
hostnamectl set-hostname localhost

# Remove lines in /etc/apt/sources.list for CDROM
echo '> Removing CDROM references from apt sources.list'
sed -i '/cdrom/d' /etc/apt/sources.list

# Perform apt update and apt upgrade
echo '> Performing apt update/upgrade'
apt update && apt -y upgrade

# Autoremove and cleans apt-get.
echo '> Cleaning apt-get ...'
apt-get autoremove && apt-get clean

# Cleans the machine-id.
echo '> Cleaning the machine-id ...'
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id