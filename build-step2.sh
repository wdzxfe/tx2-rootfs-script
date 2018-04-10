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

#clean
apt-get clean
apt-get autoremove
