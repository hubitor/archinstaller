if [ ! $ADD_USERS_LIB ]
then ADD_USERS_LIB=1

# dependancies
. shellib/lib/style

add_users() {
  echo "Add Users" | section

  local sel user mnt="$1"

  while true; do
    read -rp "Create a new user? [Y/n]: " sel
    if [ "$sel" == "n" ]; then
      break
    else
      read -rp "Username: " user
      read -rp "User groups: " groups
      
      arch-chroot "$mnt" \
        useradd -mUG "$groups" "$user"

      arch-chroot "$mnt" \
        passwd "$user"
    fi
  done
}

fi  # ADD_USERS_LIB
