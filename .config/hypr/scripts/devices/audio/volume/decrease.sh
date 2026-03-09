#!/bin/bash

info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@);

# Unmute if muted
if grep -q "\[MUTED\]" <<< "$info"; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
fi

wpctl set-volume @DEFAULT_AUDIO_SINK@ "1%-" -l 1

vol=$(awk '{print $2*100-1}' <<< "$info");
# TODO: The icon has to be dynamic.
notify-send -a system -h string:x-dunst-stack-tag:volume -h int:value:"$vol" -i "/home/morder/.assets/icons/misc/volume/white_high.png" "volume";