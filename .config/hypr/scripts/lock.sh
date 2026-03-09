#!/bin/bash

pkill -SIGUSR1 dunst # pause 

pidof hyprlock || hyprlock -q
# loginctl lock-session

pkill -SIGUSR2 dunst # resume 