#!/bin/bash

# Script for using variables for specific machines. Will use template if the device is not recognized.

BOARD_SERIAL=$(sudo dmidecode -s baseboard-serial-number)
case "$BOARD_SERIAL" in
    "190857286901756")
        HOST_DEVICE="home-desktop"
        ;;
    "L1HF44R00V4")
        HOST_DEVICE="lenovo-laptop"
        ;;
    *)
        notify-send "Config" "This device is not recognized. Using default device settings." -u normal # TODO: Attach action to open VSCode to configure for device.
        HOST_DEVICE=".variables-template"
        ;;
esac

ln -sf $HOST_DEVICE.conf $HOME/.config/hypr/config/variables/active.conf

hyprctl reload &>/dev/null