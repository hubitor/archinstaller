#!/bin/bash

# config stuff
ROOT_MOUNT="/mnt"
BOOT_MOUNT="/mnt/boot"
MIRRORLIST="/etc/pacman.d/mirrorlist"
COUNTRY="United States"
REGION="US"
CITY="Central"
PKGS="pkgs"

# color stuff
CLEAR="\033[0m"
_CLEAR="\\033\[0m"
BOLD="\033[1m"
RED="\033[0;31m"

# don't touch stuff
BOOT_MODE=
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
  
  if [ -e "/sys/firmware/efi/efivars" ]; then
    BOOT_MODE="UEFI"
  else
    BOOT_MODE="BIOS"
  fi
  echo "Boot Mode: "$BOOT_MODE""
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
  local disk disks parts
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

  mount "$ROOT_PART" "$ROOT_MOUNT" | indent '    '
  mkdir /mnt/boot
  mount "$BOOT_PART" "$BOOT_MOUNT" | indent '    '

  lsblk
}

select_mirrors() {
  echo "Select Mirrors" | section

  cp "$MIRRORLIST" mirrorlist.bak
  cat mirrorlist.bak | awk '
    BEGIN {cond = 0}
    /'"$COUNTRY"'/ {cond = 1}
    {
      if (cond == 1) {
        print $0;
        cond++;
      }
      else if (cond == 2) {
        print $0;
        cond = 0;
      }
    }
  ' | tee "$MIRRORLIST" | indent '    '
}

install_packages() {
  echo "Install Packages" | section

  for pkg in $(cat "$PKGS"); do
    pacstrap "$ROOT_MOUNT" "$pkg"
  done
}

generate_fstab() {
  echo "Generate Fstab" | section

  genfstab -U "$ROOT_MOUNT" >> "$ROOT_MOUNT"/etc/fstab
}

set_timezone() {
  echo "Set Localtime" | section
  echo "NOT IMPLEMENTED"

  arch-chroot "$ROOT_MOUNT" \
    ln -sf /usr/share/zoneinfo/"$REGION"/"$CITY" /etc/localtime

  arch-chroot "$ROOT_MOUNT" hwclock --systohc
}

set_locale() {
  echo "Set Locale" | section

  echo "Uncomment en_US.UTF-8 UTF-8 and other needed localizations in /etc/locale.gen"
  sleep 1
  vim "$ROOT_MOUNT"/etc/locale.gen
  arch-chroot "$ROOT_MOUNT" locale-gen
}

set_hostname() {
  echo "Set Hostname" | section

  local hostname
  read -rp "Hostname: " hostname

  arch-chroot "$ROOT_MOUNT" echo "$hostname" > /etc/hostname
  arch-chroot "$ROOT_MOUNT" \
    echo -e "127.0.1.1\t"$hostname".localdomain\t"$hostname"" > /etc/hostname
}

configure_network() {
  echo "Configure Network" | section
  echo "doesnt do anything"
}

set_root_password() {
  echo "Set Root Password" | section

  arch-chroot "$ROOT_MOUNT" passwd
}

install_grub() {
  arch-chroot "$ROOT_MOUNT" \
    grub-install \
      --target=x86_64-efi \
      --efi-directory=/boot \
      --bootloader-id=boot
  arch-chroot "$ROOT_MOUNT" \
    grub-mkconfig -o /boot/grub/grub.cfg
}

install_systemd_boot() {
  arch-chroot "$ROOT_MOUNT" \
    bootctl --path=/boot install

  echo  "default arch" > loader.conf
  echo  "timeout 4" >> loader.conf
  echo  "editor 0" >> loader.conf
  cat loader.conf > "$BOOT_MOUNT"/loader/loader.conf

  echo "title arch" > arch.conf
  echo "linux /vmlinuz-linux" >> arch.conf
  echo "initrd /intel-ucode.img" >> arch.conf
  echo "initrd /initramfs-linux.img" >> arch.conf
  cat arch.conf > "$BOOT_MOUNT"/loader/entries/arch.conf
}

set_bootloader() {
  echo "Setup Bootloader" | section

  local loader
  
  echo -e "grub\nsystemd" | menu "Select bootloader:"
  read -rp "bootloader: " loader

  case "$loader" in
    "1")
      install_grub
      ;;
    "2")
      install_systemd_boot
      ;;
  esac
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
#set_keyboard_layout
verify_boot_mode
#connect_internet
#update_system_clock
#partition_disks
#format_partitions
#mount_filesystem
#select_mirrors
#install_packages
#generate_fstab
#set_timezone
#set_locale
#set_hostname
#configure_network
#set_root_password
#set_bootloader
#reboot_system
