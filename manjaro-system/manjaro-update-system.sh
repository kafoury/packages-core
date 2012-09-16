#!/bin/bash

SYSTEMVERSION="0"

if [ -f /var/lib/manjaro-system/version ]; then
	. /var/lib/manjaro-system/version
fi


post_install() {
	post_upgrade
}

post_upgrade() {
	if [ "$SYSTEMVERSION" -lt "20120916" ]; then
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

		# Update system version
		echo "SYSTEMVERSION=\"20120916\"" > /var/lib/manjaro-system/version
	fi
}
