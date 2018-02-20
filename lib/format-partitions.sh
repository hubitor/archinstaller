if [ ! $FORMAT_PARTITIONS_LIB ]
then FORMAT_PARTITIONS_LIB=1

# dependancies
. shellib/lib/style
#. partition-disks.sh

format_partitions() {
  section "Format Disk Partitions"

  local boot="$1" root="$2" swap="$3"

  # boot partition
  style -s bold -i '  ' -- \
    "\nFormat Boot Partition: [$boot]"
  mkfs.fat -F32 "$BOOT_PART" 2>&1 | style -i '    '

  # swap partition
  if [ $swap ]; then
    style -s bold -i '  ' -- \
      "\nFormat Swap Partition: [$swap]"
    mkswap "$swap" 2>&1 | style -i '    '
    swapon "$swap" 2>&1 | style -i '    '
  fi

  # main partition
  style -s bold -i '  ' -- \
    "\nFormat Main Partition: [$root]"
  mkfs.btrfs -f "$ROOT_PART" 2>&1 | style -i '    '
}

fi  # FORMAT_PARTITIONS_LIB
