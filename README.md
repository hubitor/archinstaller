# Arch Linux Install Script
A quick and dirty archlinux install script. 

It works for what I need feel free to make it your own, but it is not intended
to be a general solution for people who dont know how to install arch.

Just add any packages you want installed to the pkgs text file.

Using a a base install image run the following.
```
mount -o remount,size=2G /run/archiso/cowspace && pacman -Sy git && git clone https://github.com/jeremyCloud/archinstaller && cd archinstaller
```
update the pkgs file then:
```
./archinstaller.sh
```
