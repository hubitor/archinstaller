if [ ! $SET_HOSTNAME_LIB ]
then SET_HOSTNAME_LIB=1

# dependancies
. shellib/lib/style

set_hostname() {
  section "Set Hostname"

  local hostname mnt="$1"

  read -rp "Hostname: " hostname

  arch-chroot "$mnt" \
    echo "$hostname" > /etc/hostname
  arch-chroot "$mnt" \
    echo -e "127.0.1.1\t${hostname}.localdomain\t${hostname}" > /etc/hostname
}

fi  # SET_HOSTNAME_LIB
