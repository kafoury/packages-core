#!/bin/bash

PACKAGEVERSION="20130501"
SYSTEMVERSION="$PACKAGEVERSION"

if [ -f /var/lib/manjaro-system/version ]; then
	. /var/lib/manjaro-system/version
fi

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



post_upgrade() {
	# Remove systemd-next
	if [ "$(pacman -Qq | grep systemd-next)" != "" ]; then
		msg "Replacing systemd-next with systemd ..."
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -Rdd systemd-next
		pacman --noconfirm -S systemd systemd-sysvcompat
	fi
	if [ "$(pacman -Qq | grep lib32-systemd-next)" != "" ]; then
		msg "Replacing lib32-systemd-next with lib32-systemd ..."
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -Rdd lib32-systemd-next
		pacman --noconfirm -S lib32-systemd
	fi

	# Install systemd-sysvcompat
	if [ "$(pacman -Qq | grep systemd-sysvcompat)" == "" ]; then
		msg "Installing missing systemd-sysvcompat ..."
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -S systemd systemd-sysvcompat
	fi

	# Fix turbojpeg
	if [ -e /usr/bin/tjbench ] ; then
	if [ "x`pacman -Qo /usr/bin/tjbench | grep libjpeg-turbo`" != "x" ]; then
		msg "Fixing turbojpeg ..."
		rm -f /usr/bin/tjbench
		rm -f /usr/include/turbojpeg.h
		rm -f /usr/lib/libturbojpeg.a
		rm -f /usr/lib/libturbojpeg.so
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -S libjpeg-turbo
	fi
	fi
	if [ "x`uname -m`" == "xx86_64" ] && [ -e /usr/lib32/libturbojpeg.so ] ; then
	if [ "x`pacman -Qo /usr/lib32/libturbojpeg.so | grep libjpeg-turbo`" != "x" ]; then
		msg "Fixing lib32-turbojpeg ..."
		rm -f /usr/lib32/libturbojpeg.{so,a}
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -S lib32-libjpeg-turbo
	fi
	fi

	# remove 99-manjaro.rules
	if [ "$(pacman -Qq manjaro-hotfixes | grep 'manjaro-hotfixes')" == "manjaro-hotfixes" ]; then
	if [ "$(pacman -Q manjaro-hotfixes | cut -d- -f2 | cut -d" " -f2 | sed -e 's/\.//g')" -lt "201303" ]; then
		msg "Fixing manjaro-hotfixes ..."
		# System operation
		rm -f /etc/polkit-1/rules.d/99-manjaro.rules
	fi
	else
		# No manjaro-hotfixes installed
		msg "Installing manjaro-hotfixes ..."
		# System operation
		rm -f /etc/polkit-1/rules.d/99-manjaro.rules
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -S manjaro-hotfixes
	fi

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
		pacman --noconfirm -Rdd ${removepkgs}
		msg "Removing linux-meta pkgs - done"
	fi

	# remove symlinks if fontconfig < 2.10.1
	if [ "$(pacman -Qq fontconfig | grep 'fontconfig')" == "fontconfig" ]; then
	if [ "$(pacman -Q fontconfig | cut -d- -f1 | cut -d" " -f2 | sed -e 's/\.//g')" -lt "2101" ]; then
		msg "Fixing fontconfig ..."
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
	fi

	# Update system version
	echo "SYSTEMVERSION=\"$PACKAGEVERSION\"" > /var/lib/manjaro-system/version
}
