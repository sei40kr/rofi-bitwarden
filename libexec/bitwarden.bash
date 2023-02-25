#!/usr/bin/env bash

copy() {
	if [[ -n "$DISPLAY" ]]; then
		xsel --clipboard
	elif [[ -n "$WAYLAND_DISPLAY" ]]; then
		wl-copy
	else
		echo 'Could not copy to clipboard. Wayland or X11 is required.' >&2
		exit 1
	fi
}

items() {
	echo -e "\0prompt\x1fSearch vault"
	echo -e "\0message\x1fAlt-u: Copy username  Alt-p: Copy password"
	echo -e "\0markup-rows\x1ftrue"
	echo -e "\0use-hot-keys\x1ftrue"
	bw list --raw --nointeraction items | jq -r '.[] | "\(.name) - <small>\(.login.username)</small>\u0000nonselectable\u001ftrue\u001finfo\u001f\(.id)"'
}

copy_username() {
	local id="$1"

	bw get --raw --nointeraction username "$id" | copy
	notify-send -u low -t 1000 "Copied username to clipboard"
}

copy_password() {
	local id="$1"

	bw get --raw --nointeraction password "$id" | copy
	notify-send -u low -t 1000 "Copied password to clipboard"
}

main() {
	case "$ROFI_RETV" in
	0)
		items
		;;

	# Copy username
	10)
		copy_username "$ROFI_INFO"
		items
		;;

	# Copy password
	11)
		copy_password "$ROFI_INFO"
		items
		;;
	esac
}

main
