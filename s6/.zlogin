#!/bin/zsh
# Read after zshrc, in login shells

# echo "Sourcing zlogin"
source /home/mazunki/.config/environment
source /home/mazunki/.config/xdg_paths

function start_default_session() {
	[ -e "${XDG_RUNTIME_DIR}" ] || mkdir -m600 "${XDG_RUNTIME_DIR}"
	mkdir -p "${XDG_RUNTIME_DIR}/s6"
	# mkdir -p /home/mazunki/.local/logs/s6

	echo "Booting usertree"
	doas s6-rc -u change usertree-mazunki

	# s6-rc-init -c compiled -l live scandir
	#
	# expects to find a compiled service db in -c compiled
	# alives the compiled in -l live
	# an instance of s6-svscan on scandir
	#
	# they start in down state
	echo "Creating services"
	s6-rc-init -c "${HOME}/.local/var/lib/s6/active_db" -l "${XDG_RUNTIME_DIR}/s6/s6-rc" "${XDG_RUNTIME_DIR}/s6/service"

	echo "Changing user runtime"
	s6-rc -l "${XDG_RUNTIME_DIR}/s6/s6-rc" -up change default
}

[ "$(tty)" = "/dev/tty2" ] && start_default_session
[ "$(tty)" = "/dev/tty2" ] && s6-rc -l "${XDG_RUNTIME_DIR}/s6/s6-rc" -up change sway

