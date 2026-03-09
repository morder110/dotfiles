#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr/.Testing-environments"

# Reset by commenting all that are not already
sed -i "/^\s*#/!s/^/# /" "$CONFIG_DIR/keybinds/keyboard/active.conf"
sed -i "/^\s*#/!s/^/# /" "$CONFIG_DIR/keybinds/mouse/active.conf"

BOARD_SERIAL=$(sudo dmidecode -s baseboard-serial-number)

case "$BOARD_SERIAL" in
    "190857286901756")
        HOST_DEVICE="home-desktop"
        ;;
    "L1HF44R00V4")
        HOST_DEVICE="lenovo-laptop"
        ;;
    *)
        echo Not implemented for this device. Using default.
        HOST_DEVICE=".variables-template"
        ;;
esac

ln -sf $HOST_DEVICE.conf $CONFIG_DIR/variables/active.conf

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
        046d:c095)
            DEVICE_NAME="logitech-g502x-plus"
            DEVICE_TYPE="mouse"
            ;;
        # Logitech G502 X PLUS
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

#!/bin/bash

# Object with monitor models as string keys
declare -A HAS_MONITOR

TOTAL_MONITORS_COUNT=$(hyprctl monitors -j | jq '. | length')

# Loop through each monitor and add to object HAS_MONITOR.
hyprctl monitors -j | jq -r '.[] | "\(.name) \(.model)"' | while read -r name model; do
    if [[ "$name" == eDP-* ]]; then
        HAS_MONITOR[LAPTOP]=1
    fi

    if [[ "$model" == "XB271HU" ]]; then
        HAS_MONITOR[XB271HU]=1
    fi

    # Using a safe key name for the Lenovo model
    if [[ "$model" == "LEN P27q-10" ]]; then
        HAS_MONITOR[LEN_P27Q10]=1
    fi
done

if [[ (-v HAS_MONITOR[LEN_P27Q10] && -v HAS_MONITOR[XB271HU] && "$TOTAL_MONITORS_COUNT" -eq 2) \
    ||(-v HAS_MONITOR[LEN_P27Q10] && -v HAS_MONITOR[XB271HU] && -v HAS_MONITOR[LAPTOP] && "$TOTAL_MONITORS_COUNT" -eq 3) ]]; then
    # HOME setup

elif [[ -v HAS_MONITOR[LAPTOP] && "$TOTAL_MONITORS_COUNT" -eq 1 ]]; then

elif [[ "$TOTAL_MONITORS_COUNT" -eq 1 ]]; then

else # Assume more than 1 monitor
    # TODO: Prompt user what they want to do with monitor script. Use gum
    # 1. Propt the user if they want to: "Manual setup", "Auto setup", or "Profiles". The title is Monitor setup

    # For manual setup:
    # 1. Open `nwg-displays -m /tmp/monitors.conf -w /tmp/workspaces.conf`
    # 2. Once it has finished, prompt the user to input a name for this profile. Only allow file name safe characters.
    # 3. Move the files /tmp/monitors.conf and /tmp/workspaces.conf to $HOME/.config/hypr/.Testing-environments/Monitors/ and add a prefix with the name above such as home-monitors.conf and home-workspaces.conf.
    # 4. Duplicate $HOME/.config/hypr/.Testing-environments/Monitors/.variables-template.conf as prefix-variables.conf in the same folder such as home-variables.conf.
    # 5. Add a symbolic link `ln -sf` for each of the 3 files created in the same directory named active-monitors.conf, active-workspaces.conf, and active-variables.conf
    # 6. Run hyprctl reload.
fi