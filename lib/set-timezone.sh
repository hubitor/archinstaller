if [ ! $SET_TIMEZONE_LIB ]
then SET_TIMEZONE_LIB=1

. shellib/lib/style

set_timezone() {
  section "Set Localtime"

  local mnt="$1" region="$2" city="$3"

  arch-chroot "$mnt" \
    ln -sf /usr/share/zoneinfo/"$region"/"$city" /etc/localtime

  arch-chroot "$mnt" \
    hwclock --systohc
}

fi  # SET_TIMEZONE_LIB
