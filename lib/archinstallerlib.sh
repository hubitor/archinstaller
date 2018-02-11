if [ ! $ARCHINSTALLER_LIB ] 
then ARCHINSTALLER_LIB=1

. lib/add-users.sh
. lib/configure-network.sh
. lib/connect-internet.sh
. lib/enable-services.sh
. lib/files.log
. lib/format-partitions.sh
. lib/generate-fstab.sh
. lib/install-aur.sh
. lib/install-packages.sh
. lib/mount-filesystem.sh
. lib/partition-disks.sh
. lib/reboot-system.sh
. lib/select-mirrors.sh
. lib/set-bootloader.sh
. lib/set-hostname.sh
. lib/set-keyboard-layout.sh
. lib/set-locale.sh
. lib/set-root-password.sh
. lib/set-timezone.sh
. lib/style.sh
. lib/update-system-clock.sh
. lib/verify-boot-mode.sh

fi  # ARCHINSTALLER_LIB
