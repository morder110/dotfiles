#!/bin/bash

# This is a fix for hypridle triggering sleep again after waking up

# NOTE: If changing this, change ALL matching lines. Sleep was hard coded some places such as hyprlock and hypridle.
[[ ! -e /tmp/sleepy-eepy ]] && touch /tmp/sleepy-eepy && systemctl suspend --now