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

  # install universal pkgs
  _paclist "$mnt" "environs/pkgs"

  # install environment pkgs
  _paclist "$mnt" "environs/$environ/pkgs"

  RETURN="$environ"
}

_paclist() {
  local mnt="$1"
  local pkgs="$2"
  local pkg

  for pkg in $(cat "$pkgs"); do
    if [[ ! "$pkg" == "#"* ]]; then
      style -s bold -b green -f white -- \
        "installing: [$pkg]"
      read
      pacstrap "$mnt" "$pkg"
    fi
  done
}

fi  # INSTALL_PKGS_LIB
