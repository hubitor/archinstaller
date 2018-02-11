if [ ! $VERIFY_BOOT_MODE_LIB ]
then VERIFY_BOOT_MODE_LIB=1

# dependancies
. style.sh

verify_boot_mode() {
  echo "Verify Boot Mode" | section
  
  if [ -e "/sys/firmware/efi/efivars" ]; then
    BOOT_MODE="UEFI"
  else
    BOOT_MODE="BIOS"
  fi
  echo "Boot Mode: "$BOOT_MODE""
}

fi  # VERIFY_BOOT_MODE_LIB
