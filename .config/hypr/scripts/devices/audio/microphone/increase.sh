#!/bin/bash

info=$(wpctl get-volume @DEFAULT_SOURCE@);

# Unmute if muted
if echo "$info" | grep -q "\[MUTED\]"; then
    wpctl set-mute @DEFAULT_SOURCE@ 0
    # brightnessctl -sd platform::micmute set 0 # TODO: Find a way to change this depending on device availability
fi

wpctl set-volume @DEFAULT_SOURCE@ "1%+" -l 1

vol=$(echo "$info" | awk '{print $2*100+1}'); # TODO: Make sure this does not go above 100
# TODO: The icon has to be dynamic.
notify-send -a system -h string:x-dunst-stack-tag:microphone -h int:value:"$vol" -i "/home/morder/.assets/icons/misc/microphone/white_high.png" "volume";