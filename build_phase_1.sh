#!/bin/bash

if [ ! -e /usr/bin/qemu-aarch64-static ] || [ ! -e /usr/sbin/debootstrap ]
then
	apt-get update
	apt-get -y install qemu-user-static debootstrap
fi

if [ -e ../rootfs/ ]
then
	mv ../rootfs/ ../rootfs_$(date +%Y%m%d%H%M)
else
	mkdir ../rootfs
fi

debootstrap \
        --arch=arm64 \
        --verbose \
        --foreign \
        --variant=minbase \
        xenial \
        ../rootfs \
	http://mirrors.ustc.edu.cn/ubuntu-ports/

cp /usr/bin/qemu-aarch64-static ../rootfs/usr/bin
cp ./build_phase_2.sh ../rootfs/
cp ./config.conf ../rootfs/

cd ../rootfs
chroot . /bin/bash -c "/debootstrap/debootstrap --second-stage" 
# continue to install via build-step2.sh
chroot . /bin/bash -c "/build_phase_2.sh"

rm ./build_phase_2.sh
rm ./config.conf
rm ./usr/bin/qemu-aarch64-static

cd -

size=$(du -sh ../rootfs)
echo "total size of rootfs with gstreamer: ${size%%.*}"
../apply_binaries.sh > /dev/null
size=$(du -sh ../rootfs)
echo "total size of rootfs with apply_binaries: ${size%%.*}"
