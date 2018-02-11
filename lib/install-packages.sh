if [ ! $INSTALL_PKGS_LIB ]
then INSTALL_PKGS_LIB=1

# dependancies
. style.sh
. partition-disks.sh

install_packages() {
  echo "Install Packages" | section

  local pkg

  for pkg in $(cat "$PKGS"); do
    if [[ ! "$pkg" == "#"* ]]; then
      pacstrap "$ROOT_MOUNT" "$pkg"
    fi
  done
}

fi  # INSTALL_PKGS_LIB
