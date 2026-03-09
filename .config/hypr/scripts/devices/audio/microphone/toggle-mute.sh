#!/bin/bash

wpctl set-mute @DEFAULT_SOURCE@ toggle
info=$(wpctl get-volume @DEFAULT_SOURCE@);
vol=$(echo "$info" | awk '{print $2*100}');
if echo "$info" | grep -q "\[MUTED\]"; then
    notify-send -a system -h string:x-dunst-stack-tag:microphone -h int:value:"$vol" -i "/home/morder/.assets/icons/misc/microphone/white_mute.png" "mute";
    # brightnessctl -sd platform::micmute set 1 # TODO: Find a way to change this depending on device availability
else
    notify-send -a system -h string:x-dunst-stack-tag:microphone -h int:value:"$vol" -i "/home/morder/.assets/icons/misc/microphone/white_high.png" "volume";
    # brightnessctl -sd platform::micmute set 0 # TODO: Find a way to change this depending on device availability
fi