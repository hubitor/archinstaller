if [ ! $INSTALL_PKGS_LIB ]
then INSTALL_PKGS_LIB=1

# dependancies
#. style.sh

install_packages() {
  echo "Install Packages" | section

  local pkg pkgs environ root_mount="$1"

  menu \
    -t 'What environment would you like to install?' \
    -p 'environ: ' \
    -- "$(ls environs)"
  environ="$RETURN"
  pkgs="environs/$environ/pkgs"

  for pkg in $(cat "$PKGS"); do
    if [[ ! "$pkg" == "#"* ]]; then
      pacstrap "$ROOT_MOUNT" "$pkg"
    fi
  done

  RETURN="$environ"
}

fi  # INSTALL_PKGS_LIB
