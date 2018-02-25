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
  menu -s ":" \
    -t '\nWould you like to install a swap partition? ' \
    -p '#? ' \
    -- yes:no
  swapon="$RETURN"
  if [ "$swapon" == 'yes' ]; then
    echo
    read -rp 'How big? You can use [K,M,G] like "2G": ' swap
  else
    swap="512M"
  fi

  # main file system
  menu -s ":" \
    -t '\nWhat file system do you want for your root file system?' \
    -p 'fs: ' \
    -- ext4:btrfs
  fs="$RETURN"

  # create the disk label and boot partition
  parted "$install_disk" mklabel gpt
  parted "$install_disk" mkpart primary fat32 0% 512M
  parted "$install_disk" toggle 1 boot

  # swap partition
  if [ "$swapon" == 'yes' ]; then
    parted "$install_disk" mkpart primary linux-swap 512M "$swap"
  fi

  # main partition
  parted "$install_disk" mkpart primary "$fs" "$swap" 100%

  # assign partition paths
  readarray -t parts <<< \
    "$(lsblk -lnpo NAME,TYPE "$install_disk" | grep part | awk '{print $1}')"

  RETURN_INSTALL="$install_disk"
  RETURN_BOOT="${parts[0]}"
  RETURN_FMT="$fs"
  if [ "$swapon" == "yes" ]; then
    RETURN_SWAP="${parts[1]}"
    RETURN_ROOT="${parts[2]}"
  else
    RETURN_ROOT="${parts[1]}"
  fi
}

fi  # PARTITION_DISKS_LIB
