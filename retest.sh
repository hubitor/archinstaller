#!/bin/bash

rm archinstaller.sh
parted /dev/vda mklabel gpt
curl https://raw.githubusercontent.com/jeremyCloud/archinstaller/master/archinstaller.sh -o \
  archinstaller.sh
chmod 755 archinstaller.sh
bash archinstaller.sh
