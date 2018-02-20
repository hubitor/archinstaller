if [ ! $MOUNT_FILESYSTEM_LIB ]
then MOUNT_FILESYSTEM_LIB=1

# dependancies
. shellib/lib/style

mount_filesystem() {
  section "Mount Filesystems"

  local boot="$1" root="$2" mnt="$3"

  # mount root partition
  mount "$root" "$mnt" | style -i '    '

  # mount boot partition
  mkdir /mnt/boot
  mount "$boot" "$mnt/boot" | style -i '    '

  # show the user what happened
  lsblk
}

fi  # MOUNT_FILESYSTEM_LIB
