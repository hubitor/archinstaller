if [ ! $GENERATE_FSTAB_LIB ]
then GENERATE_FSTAB_LIB=1

# dependancies
. shellib/lib/style

generate_fstab() {
  section "Generate Fstab"

  local mnt="$1"

  genfstab -U "$mnt" >> "$mnt/etc/fstab"
}

fi  # GENERATE_FSTAB_LIB
