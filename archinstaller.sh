#!/bin/bash

# library imports
. lib/archinstallerlib.sh

main() {
  local boot_part root_part swap_part environ 
  local mnt="/mnt"
  local region="US"
  local city="Central"
  
  set_keyboard_layout
  verify_boot_mode
  connect_internet
  update_system_clock
  uefi_partition
    install_disk="$RETURN_INSTALL"
    boot_part="$RETURN_BOOT"
    root_part="$RETURN_ROOT"
    swap_part="$RETURN_SWAP"
  format_partitions "$boot_part" "$root_part" "$swap_part"
  mount_filesystem "$boot_part" "$root_part" "$mnt"
  select_mirrors /etc/pacman.d/mirrorlist "United States"
  install_packages "$mnt"
    environ="$RETURN"
  generate_fstab "$mnt"
  set_timezone "$mnt" "$region" "$city"
  set_locale "$mnt"
  set_hostname "$mnt"
  configure_network
  set_root_password "$mnt"
  install_grub "$mnt"
  enable_services "$mnt" "environs/$environ/units"
  add_users "$mnt"
  
  style -s bold -- 'you can reboot your system now.'
}

main
