if [ ! $FORMAT_PARTITIONS_LIB ]
then FORMAT_PARTITIONS_LIB=1

# dependancies
. shellib/lib/style
#. partition-disks.sh

format_partitions() {
  section "Format Disk Partitions"

  local boot="$1" 
  local root="$2" 
  local swap="$3"
  local fmt="$4"

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
    "\nFormat Main Partition: [$root] -- $fmt"
  if [ "$fmt" == "btrfs" ]; then
    mkfs.btrfs -f "$root" 2>&1 | style -i '    '
  elif [ "$fmt" == "ext4" ]; then
    mkfs.ext4 "$root"
  fi
}

fi  # FORMAT_PARTITIONS_LIB
