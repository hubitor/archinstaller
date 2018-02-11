if [ ! $CONNECT_INTERNET_LIB ]; then CONNECT_INTERNET_LIB=1

# dependancies
#. style.sh

connect_internet() {
  echo "Check Internet Connectivity" | section

  if ! ping -c 3 8.8.8.8; then
    echo 'You must have a working internet connection for this to work.' | error
  fi
}

fi  # CONNECT_INTERNET_LIB
