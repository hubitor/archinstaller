#!/bin/bash

# library imports
. lib/archinstallerlib.sh

# config stuff
ROOT_MOUNT="/mnt"
BOOT_MOUNT="/mnt/boot"
MIRRORLIST="/etc/pacman.d/mirrorlist"
COUNTRY="United States"
REGION="US"
CITY="Central"
PKGS="pkgs"
UNITS="units"



reboot_system() {
  echo "You can reboot your system now." | section

  echo "Press any key to reboot."
  read
  echo "Rebooting..."
  sleep 2
  reboot
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
  enable_services
  add_users
  reboot_system
}

install_menu
##set_keyboard_layout
##verify_boot_mode
##connect_internet
##update_system_clock
##partition_disks
##format_partitions
##mount_filesystem
##select_mirrors
##install_packages
##generate_fstab
##set_timezone
##set_locale
##set_hostname
##configure_network
##set_root_password
##set_bootloader
#enable_services
##add_users
##reboot_system
