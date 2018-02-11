if [ ! $ENABLE_SERVICES_LIB ]
then ENABLE_SERVICES_LIB=1

# dependancies
#. style.sh

enable_services() {
  echo "Enable Services" | section

  local unit

  for unit in $(cat "$UNITS"); do
    if [[ ! "$unit" == "#"* ]]; then
      echo "$unit" | bold
      arch-chroot "$ROOT_MOUNT" \
        systemctl enable "$unit" | indent '    '
    fi
  done
}

fi  # ENABLE_SERVICES_LIB
