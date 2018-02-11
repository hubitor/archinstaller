if [ ! $INSTALL_AUR_LIB ]; then INSTALL_AUR_LIB=1

# dependancies
#. style.sh

# Install an aur pkg
# usage: install_aur pkg_name
install_aur() {
  local pkg
  pkg="$1"

  arch-chroot "$ROOT_MOUNT" \
    git clone https://aur.archlinux.org."$pkg".git "$pkg"
}

fi  # INSTALL_AUR_LIB
