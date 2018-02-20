if [ ! $VERIFY_boot_mode_LIB ]
then VERIFY_boot_mode_LIB=1

# dependancies
. shellib/lib/style

verify_boot_mode() {
  section "Verify Boot Mode"

  local boot_mode
  
  if [ -e "/sys/firmware/efi/efivars" ]; then
    boot_mode="UEFI"
  else
    boot_mode="BIOS"
  fi
  echo "Boot Mode: "$boot_mode""
  
  RETURN="$boot_mode"
}

fi  # VERIFY_boot_mode_LIB
