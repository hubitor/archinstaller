#!/bin/bash

CLEAR="\033[0m"
_CLEAR="\\033\[0m"
BOLD="\033[1m"
RED="\033[0;31m"
INSTALL_DISK=
BOOT_PART=
SWAP_DISK=
ROOT_PART=

clr() {
  while read line; do
    line="$(echo "$line" | sed -r -e "s/"$_CLEAR"//g")"
    echo -e "$line""$CLEAR"
  done
}

bold() {
  while read line; do
    echo -e "$BOLD""$line" | clr
  done
}

red() {
  while read line; do 
    echo -e "$RED""$line" | clr
  done
}

error() {
  while read line; do
    echo "ERROR: ""$line" | bold | red | clr
  done
  exit 1
}

section() {
  echo
  while read line; do
    echo "$line" | bold
  done
  sleep 1
}

indent() {
  while read line; do
    echo "$1""$line"
  done
}

menu() {
  local i=1

  echo -e "$1"
  while read line; do
    echo "${i}) ${line}" | indent '    '
    let "i++"
  done
  echo
}

set_keyboard_layout() {
  echo "Set The Keyboard Layout" | section
  echo "This currently does nothing."
}

verify_boot_mode() {
  echo "Verify Boot Mode" | section
  local _test=$(ls /sys/firmware/efi/efivars 2>/dev/null)
  #_test=$(echo "error")
  
  if [ -n "$_test" ]; then
    echo "This installer only supports EFI systems currently" | error
  fi
}

connect_internet() {
  echo "Check Internet Connectivity" | section

  if ! ping -c 3 8.8.8.8; then
    echo 'You must have a working internet connection for this to work.' | error
  fi
}

update_system_clock() {
  echo "Ensure The System Clock Is Accurate" | section
  
  timedatectl set-ntp true
}

partition_disks() {
  echo "Partition The Disk" | section

  # variables
  local disk disks parts leftovers
  readarray -t disks <<< "$(lsblk -lnp)"
  
  # disk choice menu
  echo "$(lsblk -ln)" | menu "\nChoose a disk for the OS install:"
  read -rp "disk selection: " disk
  let "disk--"

  # get the path to the 
  INSTALL_DISK="$(echo "${disks[$disk]}" | awk '{print $1}')"
  echo "${install_disk}"

  # create partition
  parted "$INSTALL_DISK" mklabel gpt
  parted "$INSTALL_DISK" mkpart primary fat32 0% 512m  # boot partition
  parted "$INSTALL_DISK" toggle 1 boot
  parted "$INSTALL_DISK" mkpart primary linux-swap 512M 8G  # swap partition
  parted "$INSTALL_DISK" mkpart primary ext4 8G 100%  # main partition

  # assign partition paths
  readarray -t parts <<< \
    "$(lsblk -lnpo NAME,TYPE | grep part | awk '{print $1}')"
  BOOT_PART="${parts[0]}"
  SWAP_PART="${parts[1]}"
  ROOT_PART="${parts[2]}"
  #echo "boot: $BOOT_PART"
  #echo "swap: $SWAP_PART"
  #echo "main: $ROOT_PART"
}

format_partitions() {
  echo "Format Disk Partitions" | section

  # boot partition
  echo -e "\nFormat Boot Partition: [$BOOT_PART]"
  mkfs.fat -F32 "$BOOT_PART" 2>&1 | indent '    '
  
  # swap partition
  echo -e "\nFormat Swap Partition: [$SWAP_PART]"
  mkswap "$SWAP_PART" 2>&1 | indent '    '
  swapon "$SWAP_PART" 2>&1 | indent '    '

  # main partition
  echo -e "\nFormat Main Partition: [$ROOT_PART]"
  mkfs.ext4 "$ROOT_PART" 2>&1 | indent '    '
}

mount_filesystem() {
  echo "Mount Filesystems" | section

  mount "$ROOT_PART" /mnt | indent '    '
  mkdir /mnt/boot
  mount "$BOOT_PART" /mnt/boot | indent '    '

  lsblk
}

select_mirrors() {
  echo "Select Mirrors" | section
  echo "NOT IMPLEMENTED"

  
}

install_packages() {
  echo "NOT IMPLEMENTED"
}

generate_fstab() {
  echo "NOT IMPLEMENTED"
}

set_timezone() {
  echo "NOT IMPLEMENTED"
}

set_locale() {
  echo "NOT IMPLEMENTED"
}

set_hostname() {
  echo "NOT IMPLEMENTED"
}

configure_network() {
  echo "NOT IMPLEMENTED"
}

set_root_password() {
  echo "NOT IMPLEMENTED"
}

set_bootloader() {
  echo "NOT IMPLEMENTED"
}

reboot_system() {
  echo "You can reboot your system now." | section
  #echo "Rebooting..."
  #sleep 2
  #reboot
}

install_menu() {
  set_keyboard_layout
  verify_boot_mode
  connect_internet
  update_system_clock
  partition_disks
  format_partitions
  mount_filesystem
  select_mirrors
  install_packages
  generate_fstab
  set_timezone
  set_locale
  set_hostname
  configure_network
  set_root_password
  set_bootloader
  reboot_system
}

install_menu

