if [ ! $FORMAT_PARTITIONS_LIB ]
then FORMAT_PARTITIONS_LIB=1

# dependancies
. style.sh
. partition-disks.sh

format_partitions() {
  echo "Format Disk Partitions" | section

  # boot partition
  if [ "$BOOT_MODE" == "UEFI" ]; then
    echo -e "\nFormat Boot Partition: [$BOOT_PART]"
    mkfs.fat -F32 "$BOOT_PART" 2>&1 | indent '    '
  fi

  # swap partition
  echo -e "\nFormat Swap Partition: [$SWAP_PART]"
  mkswap "$SWAP_PART" 2>&1 | indent '    '
  swapon "$SWAP_PART" 2>&1 | indent '    '

  # main partition
  echo -e "\nFormat Main Partition: [$ROOT_PART]"
  mkfs.btrfs "$ROOT_PART" 2>&1 | indent '    '
}

fi  # FORMAT_PARTITIONS_LIB
