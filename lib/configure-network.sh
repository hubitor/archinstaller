if [ ! $CONFIGURE_NETWORK ]
then CONFIGURE_NETWORK=1

# dependancies
. shellib/lib/style

configure_network() {
  section "Configure Network"
  echo "doesnt do anything"
  local mnt="$1"
  local environ="$2"
  local netman

  menu -s ":" \
    -t "What network manager do you want to use?" \
    -p "manager: " \
    -- NetworkManager:netctl
  netman="$RETURN"

  if [ "$environ" == "gnome" ] && [ "$netman" != "NetworkManager" ]; then
    style -f red  -- \
      "Gnome uses NetworkManager and it does it pretty well. Using something" \
      "else will break it."
    netman="NetworkManager"
  fi

  case "$netman" in
    netctl)
      _netctl "$mnt"
      ;;
    NetworkManager)
      echo "nothing"
      ;;
  esac
}

_netctl() {
  local mnt="$1"
  local pkgs=(ifplugd wpa_actiond)
  
  for pkg in ${pkgs[@]}; do
    pacstrap "$mnt" "$pkg"
  done
}

fi  # CONFIGURE_NETWORK
