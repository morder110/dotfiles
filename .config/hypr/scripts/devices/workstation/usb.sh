#!/bin/bash

# Script for when adding or removing USB devices to perform actions depending on the plugged in devices.
# NOTE: It does not know that a device has been removed, so the script will always reset changes to off
#       state for all devices, before proceeding to performing the actions again.

CONFIG_DIR="$HOME/.config/hypr/config"

# Reset by commenting all that are not already.
sed -i "/^\s*#/!s/^/# /" "$CONFIG_DIR/keybinds/keyboard/active.conf"
sed -i "/^\s*#/!s/^/# /" "$CONFIG_DIR/keybinds/mouse/active.conf"

# Cycle all USB devices and enable configuration files accordingly.
for DEVICE in /sys/bus/usb/devices/*; do
    if [ ! -f "$DEVICE/product" ]; then
        continue
    fi

    VENDOR_ID=$(cat "$DEVICE/idVendor")
    PRODUCT_ID=$(cat "$DEVICE/idProduct")

    if [ -z "$PRODUCT_ID" ]; then
        continue
    fi

    case "${VENDOR_ID}:${PRODUCT_ID}" in
        # XVX Izakaya
        0c45:8006)
            DEVICE_NAME="xvx-izakaya"
            DEVICE_TYPE="keyboard"
            ;;
        # Logitech G502 X PLUS
        046d:c095)
            DEVICE_NAME="logitech-g502x-plus"
            DEVICE_TYPE="mouse"
            ;;
        # Logitech G PRO X
        # Samsung T7 SSD 1TB
        046d:0aaa|04e8:4001|*)
            continue
            ;;
    esac

    sed -i \
        -e "/${DEVICE_NAME}/c\source=./${DEVICE_NAME}.conf" \
        "$CONFIG_DIR/keybinds/${DEVICE_TYPE}/active.conf"
done

hyprctl reload &>/dev/null