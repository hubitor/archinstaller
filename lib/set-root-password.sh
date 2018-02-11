if [ ! $SET_ROOT_PASSWORD_LIB ]
then SET_ROOT_PASSWORD_LIB=1

# dependancies
. style.sh

set_root_password() {
  echo "Set Root Password" | section

  arch-chroot "$ROOT_MOUNT" \
    passwd
}

fi  # SET_ROOT_PASSWORD_LIB
