if [ ! $ENABLE_SERVICES_LIB ]
then ENABLE_SERVICES_LIB=1

# dependancies
. shellib/lib/style

enable_services() {
  echo "Enable Services" | section

  local unit mnt="$1" units="$2"

  for unit in $(cat "$units"); do
    if [[ ! "$unit" == "#"* ]]; then
      style -s bold -- "$unit"
      arch-chroot "$mnt" \
        systemctl enable "$unit" | style -i '    '
    fi
  done
}

fi  # ENABLE_SERVICES_LIB
