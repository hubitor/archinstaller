if [ ! $PARTITION_DISKS_LIB ]
then PARTITION_DISKS_LIB=1

# dependancies
. shellib/lib/style
. shellib/lib/menu

uefi_partition() {
  # ok i have no bios stuff and i dont want bios stuff so this
  section "Partition The Disk"

  # variables
  local fs disk parts install_disk boot swapon swap=0
  
  # disk choice menu
  menu -c -s $'\n' \
    -t '\nWhere do you want to install Arch?'\
    -p 'Disk: ' \
    -- "$(lsblk -lnp)"
  install_disk="$(echo "$RETURN" | awk '{print $1}')"

  # swap
  echo
  if confirm "Do you want to install a swap partition?"; then
    echo
    read -rp 'How big? You can use [K,M,G] like "2G": ' swap
    swapon='true'
  else
    swap="512M"
  fi

  # main file system
  menu -s ":" \
    -t '\nWhat file system do you want for your root file system?' \
    -p 'fs: ' \
    -- ext4:btrfs
  fs="$RETURN"

  # wipe the disk
  parted -s "$install_disk" mklabel msdos
  parted -s "$install_disk" mklabel gpt

  # create the disk label and boot partition
  parted -s "$install_disk" mklabel gpt
  parted -s "$install_disk" mkpart primary fat32 0% 512M
  parted -s "$install_disk" toggle 1 boot

  # swap partition
  if [ "$swapon" == 'true' ]; then
    parted -s "$install_disk" mkpart primary linux-swap 512M "$swap"
  fi

  # main partition
  parted -s "$install_disk" mkpart primary "$fs" "$swap" 100%

  # assign partition paths
  readarray -t parts <<< \
    "$(lsblk -lnpo NAME,TYPE "$install_disk" | grep part | awk '{print $1}')"

  RETURN_INSTALL="$install_disk"
  RETURN_BOOT="${parts[0]}"
  RETURN_FMT="$fs"
  if [ "$swapon" == 'true' ]; then
    RETURN_SWAP="${parts[1]}"
    RETURN_ROOT="${parts[2]}"
  else
    RETURN_ROOT="${parts[1]}"
  fi
}

fi  # PARTITION_DISKS_LIB
