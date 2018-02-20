if [ ! $UPDATE_SYSTEM_CLOCK_LIB ]
then UPDATE_SYSTEM_CLOCK_LIB=1

# dependancies
#. style.sh

update_system_clock() {
  section "Ensure The System Clock Is Accurate"

  echo "timedatectl set-ntp true"
  timedatectl set-ntp true
}

fi  # UPDATE_SYSTEM_CLOCK_LIB
