#!/bin/bash
apt-get -y install qemu-user-static debootstrap
mkdir ../rootfs
export ARCH=arm64
RELEASE=xenial

debootstrap \
        --arch=$ARCH \
        --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg \
        --verbose \
        --foreign \
        --variant=minbase \
        $RELEASE \
        ../rootfs \
	http://mirrors.ustc.edu.cn/ubuntu-ports/

cp /usr/bin/qemu-aarch64-static ../rootfs/usr/bin
cp ./build-step2.sh ../rootfs/

cd ../rootfs
chroot . /bin/bash -c "/debootstrap/debootstrap --second-stage" 
# Open a QEMU shell to make any additional modifications. You can use apt-get at this point.
chroot . /bin/bash

rm ./build-step2.sh
rm ./usr/bin/qemu-aarch64-static
# When done create a filesystem archive
# sudo tar -cvjSf Tegra_Linux_Sample-Root-Filesystem_${RELEASE}_${PACKAGE}_aarch64.tbz2 *
cd -
echo "total size of rootfs:"
du -sh ../rootfs
echo "size of sub-directory:"
du -sh ../rootfs/* | sort -nr
