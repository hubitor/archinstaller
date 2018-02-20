if [ ! $SET_BOOTLOADER_LIB ]
then SET_BOOTLOADER_LIB=1

# dependancies
#. style.sh
. shellib/lib/style

install_grub() {
  section "Install Grub"

  local mnt="$1"

  arch-chroot "$mnt" \
    grub-install \
      --target=x86_64-efi \
      --efi-directory=/boot \
      --bootloader-id=boot
  arch-chroot "$mnt" \
    grub-mkconfig -o /boot/grub/grub.cfg
}

fi  # SET_BOOTLOADER_LIB
