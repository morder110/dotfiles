#!/bin/bash

pkill -x waybar &
pkill -x wl-paste &
pkill -x dunst &
pkill -x hypridle &
pkill -x pypr &
pkill -x hyprsunset &
pkill -x swww-daemon &
pkill -x swaybg &
pkill -f 'polkit-gnome-authentication-agent-1' &
pkill -x pipewire &
pkill -x wireplumber &
pkill -x xdg-desktop-portal-hyprland &
pkill -x xdg-desktop-portal-wlr &
pkill xdg-desktop-portal &
pkill -x hyprland-socket & # Event listener(s) using socket2

pkill -x code &

# TODO: Also pkill all programs running. It seems the instances are sometimes kept alive.

sleep 1

hyprctl dispatch exit 0