if [ ! $SET_BOOTLOADER_LIB ]
then SET_BOOTLOADER_LIB=1

# dependancies
#. style.sh

install_grub() {
  #INSTALL_DISK="/dev/vda"
  #ROOT_MOUNT="/mnt"
  if [ "$BOOT_MODE" == "UEFI" ]; then
    arch-chroot "$ROOT_MOUNT" \
      grub-install \
        --target=x86_64-efi \
        --efi-directory=/boot \
        --bootloader-id=boot
    arch-chroot "$ROOT_MOUNT" \
      grub-mkconfig -o /boot/grub/grub.cfg
  else
    arch-chroot "$ROOT_MOUNT" \
      grub-install --target=i386-pc "$INSTALL_DISK"
    arch-chroot "$ROOT_MOUNT" \
      grub-mkconfig -o /boot/grub/grub.cfg
  fi
}

install_systemd_boot() {
  arch-chroot "$ROOT_MOUNT" \
    bootctl --path=/boot install

  echo  "default arch" > loader.conf
  echo  "timeout 4" >> loader.conf
  echo  "editor 0" >> loader.conf
  cat loader.conf > "$BOOT_MOUNT"/loader/loader.conf

  echo "title arch" > arch.conf
  echo "linux /vmlinuz-linux" >> arch.conf
  echo "initrd /intel-ucode.img" >> arch.conf
  echo "initrd /initramfs-linux.img" >> arch.conf
  cat arch.conf > "$BOOT_MOUNT"/loader/entries/arch.conf
}

set_bootloader() {
  echo "Setup Bootloader" | section

  #local loader
  #
  #echo -e "grub\nsystemd" | menu "Select bootloader:"
  #read -rp "bootloader: " loader

  #case "$loader" in
  #  "1")
  #    install_grub
  #    ;;
  #  "2")
  #    install_systemd_boot
  #    ;;
  #esac
  install_grub
}

fi  # SET_BOOTLOADER_LIB
