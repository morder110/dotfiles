#!/bin/bash

wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@);
vol=$(awk '{print $2*100}' <<< "$info");
if grep -q "\[MUTED\]" <<< "$info"; then
    notify-send -a system -h string:x-dunst-stack-tag:volume -h int:value:"$vol" -i "/home/morder/.assets/icons/misc/volume/white_mute.png" "mute";
else
    notify-send -a system -h string:x-dunst-stack-tag:volume -h int:value:"$vol" -i "/home/morder/.assets/icons/misc/volume/white_high.png" "volume";
fi
# TODO: Fix icon not updating when notification is replaced. Reproduce: Mute then increase volume. Icon is still mute.