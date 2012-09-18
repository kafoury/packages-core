#!/bin/bash

pwd=`pwd`

if [ "`sudo cat /etc/sudoers | grep pacman-bin`" == "" ] ; then
   echo "please add '`whoami` ALL=NOPASSWD: /usr/bin/pacman' to your /etc/sudoers file"
   exit 1
fi

echo 'cleaning environment'
rm -R ${pwd}/*/{src,pkg} -f
echo 'building extramodules'
cd ${pwd}/*bbswitch && makepkg --sign -s --noconfirm
cd ${pwd}/*catalyst && makepkg --sign -s --noconfirm
cd ${pwd}/*catalyst-legacy && makepkg --sign -d --noconfirm
cd ${pwd}/*cdfs && makepkg --sign -s --noconfirm
cd ${pwd}/*fcpci && makepkg --sign -s --noconfirm
cd ${pwd}/*fcpcmcia && makepkg --sign -s --noconfirm
cd ${pwd}/*lirc && makepkg --sign -s --noconfirm
cd ${pwd}/*ndiswrapper && makepkg --sign -s --noconfirm
cd ${pwd}/*nvidia && makepkg --sign -s --noconfirm
cd ${pwd}/*nvidiabl && makepkg --sign -s --noconfirm
cd ${pwd}/*open-vm-tools-modules && makepkg --sign -s --noconfirm
cd ${pwd}/*r8168 && makepkg --sign -s --noconfirm
cd ${pwd}/*rt3562sta && makepkg --sign -s --noconfirm
cd ${pwd}/*vhba-module && makepkg --sign -s --noconfirm
if [ "`uname -m`" = "x86_64" ]; then
   cd ${pwd}/*virtualbox-modules && makepkg --sign -s
   sudo pacman -Sy gcc-libs binutils gcc
else
   cd ${pwd}/*virtualbox-modules && makepkg --sign -s --noconfirm
fi
echo 'create repo'
mkdir -p ${pwd}/repo-`uname -m`
mv ${pwd}/*/*`uname -m`.pkg* ${pwd}/repo-`uname -m`
ls ${pwd}/repo-`uname -m`
echo 'building extramodules done'
