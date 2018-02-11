if [ ! $STYLE_LIB ]; then STYLE_LIB=1

# color stuff
CLEAR="\033[0m"
_CLEAR="\\033\[0m"
BOLD="\033[1m"
RED="\033[0;31m"

pexec() {
  echo "$@"
  $@
}

clr() {
  while read line; do
    line="$(echo "$line" | sed -r -e "s/"$_CLEAR"//g")"
    echo -e "$line""$CLEAR"
  done
}

bold() {
  while read line; do
    echo -e "$BOLD""$line" | clr
  done
}

red() {
  while read line; do 
    echo -e "$RED""$line" | clr
  done
}

error() {
  while read line; do
    echo "ERROR: ""$line" | bold | red | clr
  done
  exit 1
}

section() {
  echo
  while read line; do
    echo "$line" | bold
  done
  sleep 1
}

indent() {
  while read line; do
    echo "$1""$line"
  done
}

menu() {
  local i=1

  echo -e "$1"
  while read line; do
    echo "${i}) ${line}" | indent '    '
    let "i++"
  done
  echo
}

fi  # STYLE_LIB
