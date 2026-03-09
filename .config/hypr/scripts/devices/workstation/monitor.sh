#!/bin/bash

CONNECTED_MONITORS_COUNT=$(hyprctl monitors | grep 'model:' | wc -l)

if [ $CONNECTED_MONITORS_COUNT == 1 ]; then
    TYPE="single"
else
    TYPE="multi"
fi

ln -sf $TYPE.conf $HOME/.config/hypr/config/keybinds/monitor/active.conf

sh $HOME/.config/hypr/scripts/system/devices/_monitor_profile.sh