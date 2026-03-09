#!/bin/bash

PLANE_ICON="$HOME/.icons/misc/plane.svg" # TODO: Add this icon

WIFI_BLOCKED=$(rfkill list wifi | grep -o "Soft blocked: yes")

if [ ! "$1" = "--only-notify" ]; then
    if [ -n "$WIFI_BLOCKED" ]; then
        mode="ON"
        rfkill unblock wifi
    else
        mode="OFF"
        rfkill block wifi
    fi
fi

notify-send -u low -h string:x-dunst-stack-tag:airplane_mode_notification -i "$notif" "Airplane" " mode: ${mode}"