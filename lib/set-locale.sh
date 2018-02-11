if [ ! $SET_LOCALE_LIB ]
then SET_LOCALE_LIB=1

# dependancies
. style.sh

set_locale() {
  echo "Set Locale" | section

  #echo "Uncomment en_US.UTF-8 UTF-8 and other needed localizations in /etc/locale.gen"
  #sleep 1
  vim "$ROOT_MOUNT"/etc/locale.gen
  arch-chroot "$ROOT_MOUNT" \
    locale-gen
  #echo "en_US.UTF-8 UTF-8" | tee "$ROOT_MOUNT"/etc/locale.gen
  echo "LANG=en_US.UTF-8" | tee "$ROOT_MOUNT"/etc/locale.conf
}

fi  # SET_LOCALE_LIB
