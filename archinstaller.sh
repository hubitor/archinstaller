#!/bin/bash

CLEAR="\033[0m"
_CLEAR="\\033\[0m"
BOLD="\033[1m"
RED="\033[0;31m"
declare -a BUILDARRAY

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
  echo "NOT IMPLEMENTED"

  # variables
  local install_disk disk disks leftovers
  readarray -t disks <<< "$(lsblk -lnp)"
  
  # disk choice menu
  echo "$(lsblk -ln)" | menu "\nChoose a disk for the OS install:"
  read -rp "disk selection: " disk
  let "disk--"

  # get the path to the 
  install_disk="$(echo "${disks[$disk]}" | awk '{print $1}')"
  echo "${install_disk}"

  # partition the drive
  parted "$install_disk" mklabel gpt
  parted "$install_disk" mkpart primary fat32 0% 512m  # boot partition
  parted "$install_disk" mkpart primary linux-swap(v1) 512M 8G  # swap partition
  parted "$install_disk" mkpart primary ext4 8G 100%  # main partition
}

format_partitions() {
  echo "NOT IMPLEMENTED"
}

mount_filesystem() {
  echo "NOT IMPLEMENTED"
}

select_mirrors() {
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

#install_menu
partition_disks

