if [ ! $PARTITION_DISKS_LIB ]
then PARTITION_DISKS_LIB=1

# dependancies
#. style.sh

BOOT_MODE=UEFI
INSTALL_DISK=
BOOT_PART=
SWAP_DISK=
ROOT_PART=

partition_disks() {
  echo "Partition The Disk" | section

  # variables
  local disk disks parts
  readarray -t disks <<< "$(lsblk -lnp)"
  
  # disk choice menu
  echo "$(lsblk -ln)" | menu "\nChoose a disk for the OS install:"
  read -rp "disk selection: " disk
  let "disk--"

  # get the path to the 
  INSTALL_DISK="$(echo "${disks[$disk]}" | awk '{print $1}')"
  echo "$INSTALL_DISK"

  if [ "$BOOT_MODE" == "UEFI" ]; then
    # gpt and UEFI
    parted "$INSTALL_DISK" mklabel gpt
    parted "$INSTALL_DISK" mkpart primary fat32 0% 512m  # boot partition
    parted "$INSTALL_DISK" toggle 1 boot
    parted "$INSTALL_DISK" mkpart primary linux-swap 512M 2G  # swap partition
    parted "$INSTALL_DISK" mkpart primary btrfs 2G 100%  # main partition
    
    # assign partition paths
    readarray -t parts <<< \
      "$(lsblk -lnpo NAME,TYPE "$INSTALL_DISK" | grep part | awk '{print $1}')"
    BOOT_PART="${parts[0]}"
    SWAP_PART="${parts[1]}"
    ROOT_PART="${parts[2]}"
  else
    # mbr and BIOS
    parted "$INSTALL_DISK" mklabel msdos
    parted "$INSTALL_DISK" mkpart primary linux-swap 512M 2G  # swap partition
    parted "$INSTALL_DISK" mkpart primary btrfs 2G 100%  # main partition
    parted "$INSTALL_DISK" toggle 2 boot
    
    # assign partition paths
    readarray -t parts <<< \
      "$(lsblk -lnpo NAME,TYPE "$INSTALL_DISK" | grep part | awk '{print $1}')"
    BOOT_PART="${parts[1]}"
    SWAP_PART="${parts[0]}"
    ROOT_PART="${parts[1]}"
  fi
  echo "boot: $BOOT_PART"
  echo "swap: $SWAP_PART"
  echo "main: $ROOT_PART"
  read
}

fi  # PARTITION_DISKS_LIB
