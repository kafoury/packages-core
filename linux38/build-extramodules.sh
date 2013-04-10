#!/bin/bash

pwd=`pwd`

if [ "`sudo cat /etc/sudoers | grep pacman`" == "" ] ; then
   echo "please add '`whoami` ALL=NOPASSWD: /usr/bin/pacman' to your /etc/sudoers file"
   exit 1
fi

echo 'cleaning environment'
rm -R ${pwd}/*/{src,pkg} -f
echo 'building extramodules'
cd ${pwd}/*bbswitch && makepkg --sign -sf --noconfirm
cd ${pwd}/*broadcom-wl && makepkg --sign -sf --noconfirm
cd ${pwd}/*catalyst && makepkg --sign -df --noconfirm
cd ${pwd}/*catalyst-legacy && makepkg --sign -df --noconfirm
cd ${pwd}/*cdfs && makepkg --sign -sf --noconfirm
cd ${pwd}/*fcpci && makepkg --sign -sf --noconfirm
cd ${pwd}/*fcpcmcia && makepkg --sign -sf --noconfirm
cd ${pwd}/*lirc && makepkg --sign -sf --noconfirm
cd ${pwd}/*ndiswrapper && makepkg --sign -sf --noconfirm
cd ${pwd}/*nvidia && makepkg --sign -sf --noconfirm
cd ${pwd}/*nvidia-legacy && makepkg --sign -d --noconfirm
cd ${pwd}/*nvidiabl && makepkg --sign -sf --noconfirm
cd ${pwd}/*open-vm-tools-modules && makepkg --sign -sf --noconfirm
cd ${pwd}/*r8168 && makepkg --sign -sf --noconfirm
cd ${pwd}/*rt3562sta && makepkg --sign -sf --noconfirm
if [ "$(uname -m)" == 'i686' ] ; then
   cd ${pwd}/*slmodem && makepkg --sign -sf --noconfirm
fi
cd ${pwd}/*tp_smapi && makepkg --sign -sf --noconfirm
cd ${pwd}/*vhba-module && makepkg --sign -sf --noconfirm
cd ${pwd}/*virtualbox-modules && makepkg --sign -sf --noconfirm
cd ${pwd}/*spl && makepkg --sign -sfi --noconfirm
cd ${pwd}/*zfs && makepkg --sign -sf --noconfirm
echo 'create repo'
mkdir -p ${pwd}/repo-`uname -m`
mv ${pwd}/*/*`uname -m`.pkg* ${pwd}/repo-`uname -m`
ls ${pwd}/repo-`uname -m`
echo 'building extramodules done'
