if [ ! $SET_LOCALE_LIB ]
then SET_LOCALE_LIB=1

# dependancies
. shellib/lib/style

set_locale() {
  section "Set Locale"

  local mnt="$1"

  #echo "Uncomment en_US.UTF-8 UTF-8 and other needed localizations in /etc/locale.gen"
  #sleep 1
  vim "$mnt"/etc/locale.gen
  arch-chroot "$mnt" \
    locale-gen
  #echo "en_US.UTF-8 UTF-8" | tee "$ROOT_MOUNT"/etc/locale.gen
  echo "LANG=en_US.UTF-8" | tee "$mnt"/etc/locale.conf
}

fi  # SET_LOCALE_LIB
