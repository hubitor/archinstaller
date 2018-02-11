if [ ! $SELECT_MIRRORS_LIB ]
then SELECT_MIRRORS_LIB=1

# dependancies
. style.sh

select_mirrors() {
  echo "Select Mirrors" | section

  cp "$MIRRORLIST" mirrorlist.bak
  cat mirrorlist.bak | awk '
    BEGIN {cond = 0}
    /'"$COUNTRY"'/ {cond = 1}
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
  ' | tee "$MIRRORLIST" | indent '    '
}

fi  # SELECT_MIRRORS_LIB
