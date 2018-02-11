if [ ! $ADD_USERS_LIB ]
then ADD_USERS_LIB=1

# dependancies
#. style.sh

add_users() {
  echo "Add Users" | section

  local sel user admin

  while true; do
    read -rp "Create a new user? [Y/n]: " sel
    if [ "$sel" == "n" ]; then
      break
    else
      read -rp "Username: " user
      read -rp "User groups: " groups
      
      arch-chroot "$ROOT_MOUNT" \
        useradd -mUG "$groups" "$user"

      arch-chroot "$ROOT_MOUNT" \
        passwd "$user"

    fi
  done
}

fi  # ADD_USERS_LIB
