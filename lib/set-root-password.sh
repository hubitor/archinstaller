if [ ! $SET_ROOT_PASSWORD_LIB ]
then SET_ROOT_PASSWORD_LIB=1

# dependancies
. shellib/lib/style

set_root_password() {
  section "Set Root Password"

  local mnt="$1"

  arch-chroot "$mnt" \
    passwd
}

fi  # SET_ROOT_PASSWORD_LIB
