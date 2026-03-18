#!/bin/bash

# Launch wlogout with size relative to active monitor size.

RESOLUTION=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | "\(.width)x\(.height)"')

if [[ -f "$HOME/.config/wlogout/size-$RESOLUTION.css" ]]; then
    echo $RESOLUTION
    wlogout --css $HOME/.config/wlogout/size-$RESOLUTION.css
else
    echo 0
    wlogout --css $HOME/.config/wlogout/style.css
fi