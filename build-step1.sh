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
# continue to install via build-step2.sh
chroot . /bin/bash -c "/build-step2.sh"

rm ./build-step2.sh
rm ./usr/bin/qemu-aarch64-static

cd -

size=$(du -sh ../rootfs)
echo "total size of based rootfs with gstreamer: ${size%%.*}"
../apply_binaries.sh > /dev/null
size=$(du -sh ../rootfs)
echo "total size of based rootfs after apply_binaries: ${size%%.*}"
