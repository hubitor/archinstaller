if [ ! $SET_HOSTNAME_LIB ]
then SET_HOSTNAME_LIB=1

# dependancies
. style.sh

set_hostname() {
  echo "Set Hostname" | section

  local hostname
  read -rp "Hostname: " hostname

  arch-chroot "$ROOT_MOUNT" \
    echo "$hostname" > /etc/hostname
  arch-chroot "$ROOT_MOUNT" \
    echo -e "127.0.1.1\t"$hostname".localdomain\t"$hostname"" > /etc/hostname
}

fi  # SET_HOSTNAME_LIB
