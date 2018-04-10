#!/bin/bash

#add apt source for arm
echo "deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse restricted universe" >> /etc/apt/sources.list
apt-get update

#install some base software
apt-get -y install sudo ssh net-tools iputils-ping --no-install-recommends

#add root passwd, add user ubuntu and nvidia
echo "***************************************************"
echo "   passwd root, please enter the passwd for root   "
echo "***************************************************"
passwd root
echo "***************************************************"
echo "      adduser ubuntu, please enter the passwd      "
echo "***************************************************"
adduser ubuntu
echo "***************************************************"
echo "      adduser nvidia, please enter the passwd      "
echo "***************************************************"
adduser nvidia

#set hostname & hosts
echo "tegra-ubuntu" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 tegra-ubuntu" >> etc/hosts

#network config

#clean
apt-get clean
apt-get autoremove
