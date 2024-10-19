#!/bin/bash
OS_VER=`hostnamectl | grep "CentOS" | awk '{print $5}'`
while [ ! -e /dev/cdrom ]
do
        clear
        echo "Seems no cdrom device attached to this VM. Please attach a cdrom device first."
done

mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom

while [ ! -e /mnt/cdrom/VBoxLinuxAdditions.run ]
do
        clear
        echo "Please insert Virtualbox Guest Additions.\n Go to Devices => Insert Guest Additions CD image..."
done

[ $OS_VER -ge 8 ] && installer="dnf" || installer="yum"
echo "$installer install -y epel-release" | bash
echo "$installer update -y" | bash
echo "$installer install -y dkms gcc kernel-devel-$(uname -r)  kernel-headers-$(uname -r) make bzip2 elfutils-libelf-devel perl" | bash
echo 'export KERN_DIR=/usr/src/kernels/$(uname -r)' >> /etc/profile
source /etc/profile
yes | sh /mnt/cdrom/VBoxLinuxAdditions.run
reboot
