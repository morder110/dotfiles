#!/bin/bash

# Script for when adding or removing monitors to change which configuration files are used depending on the plugged in devices.
# If a set of monitors have not been configured, user will be prompted to use the monitor setup wizard.

PROFILE_DIR="$HOME/.config/hypr/config/Monitors"

# The 'sed' command cleans up the output, and 'sort' ensures the order is consistent, making the comparison reliable.
CONNECTED_MONITORS=$(hyprctl monitors | grep 'model:' | sed 's/^[ \t]*model:[ \t]*//' | sort)

# Iterate over each item in the profile directory.
for PROFILE_PATH in "$PROFILE_DIR/"*; do
    # Ensure directory and not the "active" symbolic link.
    if [ ! -d "$PROFILE_PATH" ] || [ -L "$PROFILE_PATH" ]; then
        continue
    fi

    MONITOR_NAMES_FILE="$PROFILE_PATH/.monitor-combination"

    SAVED_MONITORS=$(sort "$MONITOR_NAMES_FILE")

    # Compare the connected monitors with the monitors listed in the profile.
    if [ "$CONNECTED_MONITORS" == "$SAVED_MONITORS" ]; then
        # If they match, print the profile's directory name and exit successfully.
        PROFILE_NAME=$(basename "$PROFILE_PATH")
        ln -sfn $PROFILE_NAME $PROFILE_DIR/active
        gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "Profile '${PROFILE_NAME}' has been applied."

        hyprctl reload &>/dev/null
        exit 0
    fi
done

# No matches, use setup wizard
sh $HOME/.config/hypr/scripts/system/devices/_monitor_setup.sh