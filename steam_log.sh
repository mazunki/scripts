#!/bin/sh
STEAM_HOME=${STEAM_HOME:-/opt/games/steam}
PICKER="${PICKER:-fzf --select-1}"
VISUAL="${VISUAL:-bat -l log}"

get_steam_games() {
	find "${STEAM_HOME:?No steam home given}" \
		-maxdepth 1 -type f -name '*.acf' \
		-exec awk -F'"' '
			/"appid|name/ { printf $4 "\t" }
			END { print "\n" }
		' {} \;
}

pick_steam_game() {
	if test -n "$1"; then
		get_steam_games | grep -i -e "$1" | ${PICKER:?No picker given} | cut -f1
	else
		get_steam_games | ${PICKER:?No picker given} | cut -f1
	fi
}

GAME_ID=$(pick_steam_game "$1")

test -f "${STEAM_HOME}"/steam-"${GAME_ID}".log ||
	{ printf "PROTON_LOG=1 was probably not given. No log found for game "${GAME_ID}".\n" && exit 1; }

sed '/trace\|fixme/d' "${STEAM_HOME}"/steam-"${GAME_ID}".log | ${VISUAL}


