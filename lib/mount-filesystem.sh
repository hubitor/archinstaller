if [ ! $MOUNT_FILESYSTEM_LIB ]
then MOUNT_FILESYSTEM_LIB=1

# dependancies
. style.sh
. partition-disks.sh

mount_filesystem() {
  echo "Mount Filesystems" | section

  mount "$ROOT_PART" "$ROOT_MOUNT" | indent '    '

  if [ "$BOOT_MODE" == "UEFI" ]; then
    mkdir /mnt/boot
    mount "$BOOT_PART" "$BOOT_MOUNT" | indent '    '
  fi

  lsblk
}

fi  # MOUNT_FILESYSTEM_LIB
