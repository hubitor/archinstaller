#!/bin/bash


install_drive_menu() {
  IFS=$'\n'
  PS3=$'\ndrive: '
  echo
  echo "Choose a drive to install arch to:"
  echo '----------------------------------'
  select opt in $(lsblk -lpn); do
    DRIVE="$(echo "$opt" | awk '{ print $1 }')"
  
    read -rp "Confirm ${DRIVE}? [Y/n]: " confirm
    if [[ $confirm =~ ^[yY] ]]; then
      break
    fi
  done
}

