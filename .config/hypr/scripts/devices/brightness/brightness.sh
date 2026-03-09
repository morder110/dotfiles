#!/bin/bash
# TODO: If laptop, use brightness, otherwise, use hyprsunset.

ICON_DIR="$HOME/.config/dunst/icons/brightness"
NOTIFICATION_TIMEOUT=1000

# Get brightness
get_backlight() {
	echo $(brightnessctl -m | cut -d, -f4)
}

# Get icons
get_icon() {
	current=$(get_backlight | sed 's/%//')
	if   [ "$current" -le "20" ]; then
		icon="$ICON_DIR/brightness-20.png"
	elif [ "$current" -le "40" ]; then
		icon="$ICON_DIR/brightness-40.png"
	elif [ "$current" -le "60" ]; then
		icon="$ICON_DIR/brightness-60.png"
	elif [ "$current" -le "80" ]; then
		icon="$ICON_DIR/brightness-80.png"
	else
		icon="$ICON_DIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	notify-send -e -a system -h string:x-dunst-stack-tag:brightness -h int:value:$current -u low -i "$icon" "brightness"
}

# Change brightness
change_backlight() {
	brightnessctl set "$1" -n && get_icon && notify_user
}

# Execute accordingly
case "$1" in
	"--get")
		get_backlight
		;;
	"up")
		change_backlight "+10%"
		;;
	"down")
		change_backlight "10%-"
		;;
	*)
		get_backlight
		;;
esac
