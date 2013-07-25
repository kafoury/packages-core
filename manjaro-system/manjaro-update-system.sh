
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
	# workaround for bug: http://bugs.manjaro.org/index.php?do=details&task_id=124
	cmd1="$(pacman -Qq bluez4 &> /tmp/cmd1)"
	cmd2="$(pacman -Q bluez &> /tmp/cmd2)"
	if [ "$(vercmp $2 20130725-1)" -lt 0 ] && [ "$(grep 'bluez4' /tmp/cmd1)" != "bluez4" ] && [ "$(cat /tmp/cmd2 | cut -d. -f1 | cut -d" " -f2)" -lt "5" ]; then
		msg "Fixing bluez ..."
		rm /var/lib/pacman/db.lck
		pacman --noconfirm -Rdd bluez
		pacman --noconfirm -S bluez4 bluez-libs
	fi

	# remove pyc-files if python-gobject < 3.8.3
	cmd1="$(pacman -Qq python-gobject &> /tmp/cmd1)"
	cmd2="$(pacman -Q python-gobject &> /tmp/cmd2)"
	if [ "$(vercmp $2 20130707-3)" -lt 0 ] && [ "$(grep 'python-gobject' /tmp/cmd1)" == "python-gobject" ] && [ "$(cat /tmp/cmd2 | cut -d- -f2 | cut -d" " -f2 | sed -e 's/\.//g')" -lt "383" ]; then
		msg "Fixing python-gobject ..."
		# System operation
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/__init__.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/__init__.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/importer.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/importer.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/module.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/module.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/pygtkcompat.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/pygtkcompat.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/types.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/__pycache__/types.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/_glib/__pycache__/__init__.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/_glib/__pycache__/__init__.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/_glib/__pycache__/option.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/_glib/__pycache__/option.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/__init__.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/__init__.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/constants.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/constants.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/propertyhelper.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/propertyhelper.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/signalhelper.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/_gobject/__pycache__/signalhelper.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/GIMarshallingTests.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/GIMarshallingTests.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/GLib.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/GLib.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/GObject.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/GObject.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Gdk.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Gdk.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Gio.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Gio.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Gtk.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Gtk.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Pango.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/Pango.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/__init__.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/__init__.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/keysyms.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/overrides/__pycache__/keysyms.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/gi/repository/__pycache__/__init__.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/gi/repository/__pycache__/__init__.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/pygtkcompat/__pycache__/__init__.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/pygtkcompat/__pycache__/__init__.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/pygtkcompat/__pycache__/generictreemodel.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/pygtkcompat/__pycache__/generictreemodel.cpython-33.pyo
		rm -f /usr/lib/python3.3/site-packages/pygtkcompat/__pycache__/pygtkcompat.cpython-33.pyc
		rm -f /usr/lib/python3.3/site-packages/pygtkcompat/__pycache__/pygtkcompat.cpython-33.pyo
	fi

	# Update filesystem to /usr/bin
	if [ "$(vercmp $2 20130606-1)" -lt 0 ] && [ ! -L "/bin" ] && [ ! -L "/sbin" ] && [ ! -L "/usr/sbin" ]; then
		msg "Binaries move to /usr/bin ..."
		msg "Please be patient."
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

			sed -i -e 's|^bin/|usr/bin/|' -e 's|^sbin/|usr/bin/|' -e 's|^usr/sbin/|usr/bin/|' -e 's|^bin$|usr/bin|' -e 's|^sbin$|usr/bin|' -e 's|^usr/sbin$|usr/bin|' "${path}"
		done

		# Move files
		for file in $files
		do
			local filename="${file##*/}"
			if [ "${filename}" == "" ]; then continue; fi

			# Check if file is a symlink
			if [ -L "${file}" ]; then
				local filelink="$(readlink "${file}")"

				# Check if destination file exists. Otherwise move the symlink.
				if [ -e "/usr/bin/${filename}" ]; then
					# Remove link
					unlink "${file}"
				elif [[ "${file}" =~ ^"/bin/".*|^"/sbin/".* ]] && [[ "${filelink}" =~ ^"../usr/bin/".* ]]; then
					# Move link to /usr/bin and update relative path
					filelink="$(echo "${filelink}" | sed 's|^\.\./usr/bin/||')"
					ln -s "${filelink}" "/usr/bin/${filename}"
					unlink "${file}"
				elif [[ "${file}" =~ ^"/bin/".*|^"/sbin/".* ]] && [[ "${filelink}" =~ ^"../".* ]]; then
					# Move link to /usr/bin and update relative path
					filelink="$(echo "${filelink}" | sed 's|^\.\./|\.\./\.\./|')"
					ln -s "${filelink}" "/usr/bin/${filename}"
					unlink "${file}"
				elif [[ "${file}" =~ ^"/usr/sbin/".* ]] && [[ "${filelink}" =~ ^"../bin/".* ]]; then
					# Move link to /usr/bin and update relative path
					filelink="$(echo "${filelink}" | sed 's|^\.\./bin/||')"
					ln -s "${filelink}" "/usr/bin/${filename}"
					unlink "${file}"
				else
					# Move link as it is
					ln -s "${filelink}" "/usr/bin/${filename}"
					unlink "${file}"
				fi
			else
				if [ -L "/usr/bin/${filename}" ]; then
					unlink "/usr/bin/${filename}"
					mv "${file}" "/usr/bin/"
				elif [ -e "/usr/bin/${filename}" ]; then
					err "'/usr/bin/${filename}' already exists! Moving file to '/usr/bin_duplicates/${filename}'"
					if [ ! -d "/usr/bin_duplicates" ]; then mkdir "/usr/bin_duplicates"; fi
					mv "${file}" "/usr/bin_duplicates/"
				else
					mv "${file}" "/usr/bin/"
				fi
			fi
		done

		# Fix /usr/bin/init symlink
		ln -sf "../lib/systemd/systemd" "/usr/bin/init"

		# filesystem should own /bin, /sbin and /usr/sbin
		local filesystem_path="/var/lib/pacman/local/$(pacman -Q filesystem | sed 's/ /-/g')/files"
		sed -i 's|^\%FILES\%|\%FILES\%\nbin\nsbin\nusr/sbin|' "${filesystem_path}"

		# Remove directories and create symlinks
		rm -fr /bin
		rm -fr /sbin
		rm -fr /usr/sbin
		ln -s usr/bin /bin
		ln -s usr/bin /sbin
		ln -s bin /usr/sbin

		msg "Now update your system."
	fi

	# Remove obsolete version file of manjaro-system
	if [ -f /var/lib/manjaro-system/version ]; then
		rm /var/lib/manjaro-system/version
	fi
}
