#!/bin/bash

# Установка дополнительных пакетов
sudo yum install -y epel-release
sudo yum install -y gcc make kernel-devel kernel-headers dkms perl

# Установка VirtualBox Guest Additions
sudo mount -o loop,ro /home/vagrant/VBoxGuestAdditions.iso /mnt
sudo sh /mnt/VBoxLinuxAdditions.run
sudo umount /mnt

# Очистка
sudo yum clean all
sudo rm -rf /var/cache/yum
sudo rm -f /home/vagrant/VBoxGuestAdditions.iso

# default креды
echo 'vagrant:vagrant' | chpasswd
