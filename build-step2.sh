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

#add ubuntu and nvidia to sduo group, which can exec sudo -S xxx
usermod -a -G sudo ubuntu
usermod -a -G sudo nvidia

#add apt source for arm
echo "deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse universe" > /etc/apt/sources.list
apt-get update

#install some basic softwares
apt-get -y --no-install-recommends install \
	sudo \
	ssh \
	upstart \
	net-tools \
	busybox-static

#add more tools supplied by busybox
applets=$(/bin/busybox --list)

for i in $applets; do
    if ! which $i > /dev/null; then
	ln -sf /bin/busybox /bin/$i
    fi
done

:<<!
#set temp hostname & hosts to run some cmds
echo $(uname -n) > /etc/hostname
echo 127.0.0.1 localhost $(uname -n) > /etc/hosts
!
#network config
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address 192.168.3.55" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
echo "gateway 192.168.3.1" >> /etc/network/interfaces
#set DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo "nameserver 114.114.114.114" >> /etc/resolv.conf
:<<!
# Install Gstreamer-1.0 on the platform with the following commands:
apt-get -y install gstreamer1.0-tools gstreamer1.0-alsa \
 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
 gstreamer1.0-libav --no-install-recommends
apt-get -y install libgstreamer1.0-dev \
 libgstreamer-plugins-base1.0-dev \
 libgstreamer-plugins-good1.0-dev \
 libgstreamer-plugins-bad1.0-dev --no-install-recommends
ln -s /dev/null /dev/raw1394
gst-inspect-1.0 --version
!
#set the final hostname & hosts same as nvidia setting
echo "tegra-ubuntu" > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "127.0.1.1 tegra-ubuntu" >> etc/hosts

#clean
apt-get clean
apt-get autoremove
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /var/log/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/*
rm -rf /etc/rc*
