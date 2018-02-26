if [ ! $CONFIGURE_NETWORK ]
then CONFIGURE_NETWORK=1

# dependancies
. shellib/lib/style
. shellib/lib/menu

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
      _NetworkManager "$mnt"
      ;;
  esac
  
  # and dhcpcd
  arch-chroot "$mnt" \
    systemctl enable dhcpcd.service
}

_netctl() {
  local mnt="$1"
  local pkgs=(ifplugd wpa_actiond dhcpcd)
  
  # download pkgs
  for pkg in ${pkgs[@]}; do
    pacstrap "$mnt" "$pkg"
  done

  # auto connections
  for intr in $(ip -br link | awk '{print $1}'); do
    case "$intr" in
      w*)
        echo
        if confirm "Enable wifi interface {$intr}?"; then
          arch-chroot "$mnt" \
            systemctl enable netctl-auto@"$intr".service
        fi
        ;;
      e*)
        echo
        if confirm "Enable ethernet interface {$intr}?"; then
          arch-chroot "$mnt" \
            systemctl enable netctl-ifplugd@"$intr".service
        fi
        ;;
      l*)
        echo loop: $intr
    esac
  done

}

_NetworkManager() {
  local mnt="$1"

  arch-chroot "$mnt" \
    systemctl enable NetworkManager.service
}

fi  # CONFIGURE_NETWORK
