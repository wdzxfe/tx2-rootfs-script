#!/bin/bash

#add root passwd, add user ubuntu and nvidia
echo -e "\n" | adduser ubuntu --disabled-login
echo -e "\n" | adduser nvidia --disabled-login
echo -e "\n"
echo "***************************************************"
echo "   passwd root, please enter the passwd for root   "
echo "***************************************************"
passwd root
echo -e "\n"
echo "***************************************************"
echo " passwd ubuntu, please enter the passwd for ubuntu "
echo "***************************************************"
passwd ubuntu
echo -e "\n"
echo "***************************************************"
echo " passwd nvidia, please enter the passwd for nvidia "
echo "***************************************************"
passwd nvidia

#add apt source for arm
echo "deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse universe" > /etc/apt/sources.list
apt-get update

#install some base softwares
apt-get -y install sudo \
	ssh \
	upstart \
	net-tools \
	iputils-ping --no-install-recommends

#set hostname & hosts
echo "tegra-ubuntu" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 tegra-ubuntu" >> etc/hosts

#network config
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address 192.168.3.55" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
echo "gateway 192.168.3.1" >> /etc/network/interfaces
# echo "dns-nameservers 8.8.8.8 8.8.4.4 114.114.114.114" >> /etc/network/interfaces
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "nameserver 114.114.114.114" >> /etc/resolv.conf

# Install Gstreamer-1.0 on the platform with the following commands:
apt-get -y install gstreamer1.0-tools gstreamer1.0-alsa \
 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
 gstreamer1.0-libav --no-install-recommends
apt-get -y install libgstreamer1.0-dev \
 libgstreamer-plugins-base1.0-dev \
 libgstreamer-plugins-good1.0-dev \
 libgstreamer-plugins-bad1.0-dev --no-install-recommends
gst-inspect-1.0 --version

#clean
apt-get clean
apt-get autoremove
#del the cache file created by apt-get update
rm -f var/cache/apt/pkgcache.bin
rm -f var/cache/apt/srcpkgcache.bin
