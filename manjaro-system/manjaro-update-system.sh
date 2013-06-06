
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
	# Remove obsolete version file of manjaro-system
	if [ -f /var/lib/manjaro-system/version ]; then
		rm /var/lib/manjaro-system/version
	fi
}
