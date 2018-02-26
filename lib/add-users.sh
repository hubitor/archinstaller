if [ ! $ADD_USERS_LIB ]
then ADD_USERS_LIB=1

# dependancies
. shellib/lib/style
. shellib/lib/menu

add_users() {
  section "Add Users"

  local sel user mnt="$1"

  while true; do

    if confirm -y "Create a new user?"; then
      read -rp "Username: " user
      read -rp "User groups: " groups
      
      arch-chroot "$mnt" \
        useradd -mUG "$groups" "$user"

      arch-chroot "$mnt" \
        passwd "$user"
    else
      break
    fi
  done
}

fi  # ADD_USERS_LIB
