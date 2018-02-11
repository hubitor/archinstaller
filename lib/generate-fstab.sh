if [ ! $GENERATE_FSTAB_LIB ]
then GENERATE_FSTAB_LIB=1

# dependancies
. style.sh

generate_fstab() {
  echo "Generate Fstab" | section

  genfstab -U "$ROOT_MOUNT" >> "$ROOT_MOUNT"/etc/fstab
}

if  # GENERATE_FSTAB_LIB
