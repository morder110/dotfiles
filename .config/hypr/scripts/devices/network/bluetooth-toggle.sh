#!/bin/bash

PLANE_ICON="$HOME/.icons/misc/plane.svg" # TODO: Use proper icon

BLUETOOTH_BLOCKED=$(rfkill list bluetooth | grep -o "Soft blocked: yes")

if [[ -n "$BLUETOOTH_BLOCKED" ]]; then
    mode="ON"
else
    mode="OFF"
fi

# Send notification before disabling due to long wait time.
notify-send -u low -h string:x-dunst-stack-tag:bluetooth_mode_notification -i "$notif" "Bluetooth" " mode: ${mode}"

# TODO: Consider adding a try-catch if an error occurs and send a new notification indicating an error on disable/enable
if [[ ! "$1" = "--only-notify" ]]; then
    if [[ -n "$BLUETOOTH_BLOCKED" ]]; then
        rfkill unblock bluetooth
    else
        rfkill block bluetooth
    fi
fi