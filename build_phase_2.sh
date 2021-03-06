#!/bin/bash

#add ubuntu and nvidia as normal users
#refer to tx2 configuration, add other groups
useradd ubuntu -m -s /bin/bash -G adm,dialout,sudo,audio,video
useradd nvidia -m -s /bin/bash -G adm,dialout,cdrom,floppy,sudo,audio,dip,video

#read configuration.txt and set passwd for root/ubuntu/nvidia
ipaddress=
gateway=

for line in $(cat config.conf)
do
	if [ ${line%%=*} == "root_passwd" ]
	then
		echo "root:${line#*=}" | chpasswd
	elif [ ${line%%=*} == "ubuntu_passwd" ]
	then
		echo "ubuntu:${line#*=}" | chpasswd
	elif [ ${line%%=*} == "nvidia_passwd" ]
	then
		echo "nvidia:${line#*=}" | chpasswd
	elif [ ${line%%=*} == "ip_address" ]
	then
		ipaddress=${line#*=}
	elif [ ${line%%=*} == "gateway" ]
	then
		gateway=${line#*=}
	else
		echo "Warning, $line is not supported!"
	fi
done

#locale setting
locale-gen en_US.UTF-8

#change apt source for arm64
echo "deb http://mirrors.ustc.edu.cn/ubuntu-ports/ xenial main multiverse universe" > /etc/apt/sources.list
apt-get update

#install some basic softwares
apt-get -y --no-install-recommends install \
	sudo \
	ssh \
	upstart \
	net-tools \
	busybox-static

# Install numpy
apt-get -y --no-install-recommends install \
 python python-dev libatlas-base-dev gcc python-numpy

# Install Gstreamer-1.0 on the platform with the following commands:
apt-get -y --no-install-recommends install \
 gstreamer1.0-tools gstreamer1.0-alsa \
 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
 gstreamer1.0-libav
gst-inspect-1.0 --version

#add more tools supplied by busybox
applets=$(/bin/busybox --list)

for i in $applets; do
    if ! which $i > /dev/null; then
	ln -sf /bin/busybox /bin/$i
    fi
done
rm /bin/[[

#network config
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address $ipaddress" >> /etc/network/interfaces
echo "gateway $gateway" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
#set DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

#set the final hostname & hosts same as nvidia setting
echo "tegra-ubuntu" > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "127.0.1.1 tegra-ubuntu" >> etc/hosts

#set rc.local as auto-startup with boot
echo "[Install]" >> /lib/systemd/system/rc-local.service
echo "WantedBy=multi-user.target" >> /lib/systemd/system/rc-local.service
ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc-local.service
chmod +x /etc/rc.local

#clean
apt-get clean
apt-get autoremove
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /var/log/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/*
