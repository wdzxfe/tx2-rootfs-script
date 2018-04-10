#!/bin/bash

#add apt source for arm
echo "deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse restricted universe" >> /etc/apt/sources.list
apt-get update

#install some base software
apt-get -y install sudo ssh net-tools iputils-ping --no-install-recommends

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

#set hostname & hosts
echo "tegra-ubuntu" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 tegra-ubuntu" >> etc/hosts

#network config
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address 192.168.3.55" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
# echo "network 192.168.3.1" >> /etc/network/interfaces
echo "gateway 192.168.3.0" >> /etc/network/interfaces
echo "dns-nameserver 8.8.8.8" >> /etc/network/interfaces

#clean
apt-get clean
apt-get autoremove
