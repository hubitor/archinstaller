if [ ! $SELECT_MIRRORS_LIB ]
then SELECT_MIRRORS_LIB=1

# dependancies
. shellib/lib/style

select_mirrors() {
  section "Select Mirrors"

  local mirrors="$1" country="$2"

  cp "$mirrors" mirrorlist.bak
  cat mirrorlist.bak | awk '
    BEGIN {cond = 0}
    /'"$country"'/ {cond = 1}
    {
      if (cond == 1) {
        print $0;
        cond++;
      }
      else if (cond == 2) {
        print $0;
        cond = 0;
      }
    }
  ' | tee "$mirrors" | style -i '    '
}

fi  # SELECT_MIRRORS_LIB
