if [ ! $SET_TIMEZONE_LIB ]
then SET_TIMEZONE_LIB=1

set_timezone() {
  echo "Set Localtime" | section
  echo "NOT IMPLEMENTED"

  arch-chroot "$ROOT_MOUNT" \
    ln -sf /usr/share/zoneinfo/"$REGION"/"$CITY" /etc/localtime

  arch-chroot "$ROOT_MOUNT" \
    hwclock --systohc
}

fi  # SET_TIMEZONE_LIB
