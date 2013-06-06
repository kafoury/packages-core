
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
	# Update filesystem to /usr/bin
	if [ "$(vercmp $2 20130606-1)" -lt 0 ] && [ ! -L "/bin" ] && [ ! -L "/sbin" ] && [ ! -L "/usr/sbin" ]; then
		msg "Binaries move to /usr/bin ..."
		local files="$(find /bin/ /sbin/ /usr/sbin/ | tr "\n" " ")"

		# List unowned files
		for file in $files
		do
			local filename="${file##*/}"
			if [ "${filename}" == "" ]; then continue; fi

			pacman -Qo "${file}" &>/dev/null
			if [ $? -ne 0 ]; then msg "Moving unowned file '${file}' to '/usr/bin'"; fi
		done

		# Update database
		local pkgs="$(pacman -Qqo /bin /sbin /usr/sbin | sort -u | tr "\n" " ")"
		for pkg in ${pkgs}
		do
			if [ "${pkg}" == "filesystem" ]; then continue; fi
			local path="/var/lib/pacman/local/$(pacman -Q ${pkg} | sed 's/ /-/g')/files"
			if [ ! -f "${path}" ]; then continue; fi

			sed -i -e 's|^bin/|usr/bin/|' -e 's|^sbin/|usr/bin/|' -e 's|^usr/sbin/|usr/bin/|' "${path}"
		done

		# Move files
# TODO: check symlinks valid!
		for file in $files
		do
			local filename="${file##*/}"
			if [ "${filename}" == "" ]; then continue; fi

			if [ -e "/usr/bin/${filename}" ]; then
				err "'/usr/bin/${filename}' already exists! Moving file to '/usr/bin_duplicates/${filename}'"
				if [ ! -d "/usr/bin_duplicates" ]; then mkdir "/usr/bin_duplicates"; fi
				mv "${file}" "/usr/bin_duplicates/"
			else
				mv "${file}" "/usr/bin/"
			fi
		done

		# Remove directories and create symlinks
		rm -fr /bin
		rm -fr /sbin
		rm -fr /usr/sbin
		ln -s /usr/bin /bin
		ln -s /usr/bin /sbin
		ln -s /usr/bin /usr/sbin

		# Update filesystem
		rm /var/lib/pacman/db.lck
		pacman --noconfirm --force -S filesystem

		msg "Run pacman -Syu again!"
	fi

	# Remove obsolete version file of manjaro-system
	if [ -f /var/lib/manjaro-system/version ]; then
		rm /var/lib/manjaro-system/version
	fi
}
