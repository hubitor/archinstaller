#!/bin/bash

# cleanup
swapoff /dev/vda2
umount /mnt/boot
umount /mnt
parted /dev/vda mklabel gpt
#rm archinstaller.sh

# download the installer script
#curl https://raw.githubusercontent.com/jeremyCloud/archinstaller/master/archinstaller.sh -o \
#  archinstaller.sh

# run the installer
bash archinstaller.sh
