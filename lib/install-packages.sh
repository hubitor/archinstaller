if [ ! $INSTALL_PKGS_LIB ]
then INSTALL_PKGS_LIB=1

# dependancies
. shellib/lib/style

install_packages() {
  Section "Install Packages"

  local pkg pkgs environ mnt="$1"

  menu -c \
    -t 'What environment would you like to install?' \
    -p 'environ: ' \
    -- "$(ls environs)"
  environ="$RETURN"
  pkgs="environs/$environ/pkgs"

  for pkg in $(cat "$pkgs"); do
    if [[ ! "$pkg" == "#"* ]]; then
      pacstrap "$mnt" "$pkg"
    fi
  done

  RETURN="$environ"
}

fi  # INSTALL_PKGS_LIB
