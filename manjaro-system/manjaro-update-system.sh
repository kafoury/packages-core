#!/bin/bash

PACKAGEVERSION="20130107"
SYSTEMVERSION="$PACKAGEVERSION"

err() {
    ALL_OFF="\e[1;0m"
    BOLD="\e[1;1m"
    RED="${BOLD}\e[1;31m"
	local mesg=$1; shift
	printf "${RED}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

msg() {
    ALL_OFF="\e[1;0m"
    BOLD="\e[1;1m"
    GREEN="${BOLD}\e[1;32m"
	local mesg=$1; shift
	printf "${GREEN}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}


if [ -f /var/lib/manjaro-system/version ]; then
	. /var/lib/manjaro-system/version
fi


post_install() {
	post_upgrade
}

post_upgrade() {
	# remove linux-meta
	for pkg in $(echo "linux linux-headers bbswitch broadcom-wl catalyst catalyst-legacy cdfs fcpci fcpcmcia lirc ndiswrapper nvidia nvidia-legacy nvidiabl open-vm-tools-modules r8168 rt3562sta vhba-module virtualbox-host-modules virtualbox-guest-modules") ; do
		for rmpkg in $(pacman -Qq | grep ${pkg}) ; do
			if [ "${pkg}" == "${rmpkg}" ] ; then
				removepkgs="${removepkgs} ${rmpkg}"
			fi
		done
	done
	if [ "x${removepkgs}" != "x" ]; then
		msg "Removing linux-meta pkgs ..."
		rm /var/lib/pacman/db.lck
		pacman --noconfirm --noprogress -Rdd ${removepkgs} > /dev/null 2>&1
		msg "Removing linux-meta pkgs - done"
	fi

	# replace 'fw mmc pata sata scsi usb virtio' with 'block'
	if [ "x$(cat /etc/mkinitcpio.conf | grep HOOKS= | grep -v '#' | grep block)" == "x" ]; then
		msg "Adjusting to 'block' hook ..."
		hooks=$(cat /etc/mkinitcpio.conf | grep HOOKS= | grep -v '#' | cut -d'"' -f2 | sed 's/fw//g' | sed 's/mmc//g' | sed 's/pata//g' | sed 's/sata//g' | sed 's/scsi//g' | sed 's/usb//g' | sed 's/virtio//g' | sed 's/filesystems/ modconf block filesystems /g' | sed 's/  / /g')
		sed -i -e "s/^HOOKS=.*/HOOKS=\"${hooks}\"/g" /etc/mkinitcpio.conf
	fi

	# remove multible 'modconf block'
	if [ "x$(cat /etc/mkinitcpio.conf | grep HOOKS= | grep -v '#' | grep 'block modconf block')" != "x" ]; then
		hooks=$(cat /etc/mkinitcpio.conf | grep HOOKS= | grep -v '#' | cut -d'"' -f2 | sed 's/modconf//g' | sed 's/block//g' | sed 's/filesystems/ modconf block filesystems /g' | sed 's/  / /g')
		sed -i -e "s/^HOOKS=.*/HOOKS=\"${hooks}\"/g" /etc/mkinitcpio.conf
	fi

	# remove symlinks if fontconfig < 2.10.1
	if [ $(pacman -Q fontconfig | cut -d- -f1 | cut -d" " -f2 | sed -e 's/\.//g') -lt "2101" ]; then
		msg "fixing fontconfig ..."
		# System operation
		rm -f /etc/fonts/conf.d/20-unhint-small-vera.conf
		rm -f /etc/fonts/conf.d/29-replace-bitmap-fonts.conf
		rm -f /etc/fonts/conf.d/30-metric-aliases.conf
		rm -f /etc/fonts/conf.d/30-urw-aliases.conf
		rm -f /etc/fonts/conf.d/40-nonlatin.conf
		rm -f /etc/fonts/conf.d/45-latin.conf
		rm -f /etc/fonts/conf.d/49-sansserif.conf
		rm -f /etc/fonts/conf.d/50-user.conf
		rm -f /etc/fonts/conf.d/51-local.conf
		rm -f /etc/fonts/conf.d/60-latin.conf
		rm -f /etc/fonts/conf.d/65-fonts-persian.conf
		rm -f /etc/fonts/conf.d/65-nonlatin.conf
		rm -f /etc/fonts/conf.d/69-unifont.conf
		rm -f /etc/fonts/conf.d/80-delicious.conf
		rm -f /etc/fonts/conf.d/90-synthetic.conf 
	fi

	# Update system version
	echo "SYSTEMVERSION=\"$PACKAGEVERSION\"" > /var/lib/manjaro-system/version
}
