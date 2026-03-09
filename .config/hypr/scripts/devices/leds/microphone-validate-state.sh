#!/bin/bash

# Validate or correct the current state of the microphone LED

# TODO: Maybe change the hard coded 'micmute' string if this causes problems with other laptops.

# Set initial led status for microphone (laptop)
MICROPHONE_DEVICE=${${$(brightnessctl -l | grep micmute | awk '{print $2}')%\'}#\'}
if [ -n MICROPHONE_DEVICE ]; then
    wpctl set-mute @DEFAULT_SOURCE@ toggle
    info=$(wpctl get-volume @DEFAULT_SOURCE@);
    vol=$(echo "$info" | awk '{print $2*100}');
    if echo "$info" | grep -q "\[MUTED\]"; then
        brightnessctl -sd platform::micmute set 1
    else
        brightnessctl -sd platform::micmute set 0
    fi
fi