#!/bin/bash

UPDATE_SOUND="$HOME/.config/hypr/sounds/update.wav"
ERROR_SOUND="$HOME/.config/hypr/sounds/error.wav"
UPDATE_ICON="$HOME/.config/hypr/icons/update.png"
DONE_ICON="$HOME/.config/hypr/icons/done.png"
WARNING_ICON="$HOME/.config/hypr/icons/warning.png"
ERROR_ICON="$HOME/.config/hypr/icons/error.png"
UPDATE_SCRIPT="$HOME/.config/hypr/scripts/package_update.sh"

# notification functions
update_notification() {
    notify-send -i "$1" "$2" "$3"
    paplay "$UPDATE_SOUND"
}

error_notification() {
    notify-send -i "$1" "$2" "$3"
    paplay "$ERROR_SOUND"
}

scripts_dir="$HOME/.config/hypr/scripts"

# function to check the package manager
check_update() {
    # tooltip in waybar
    pacman=$(checkupdates | wc -l)
    aur=$(paru -Qua | wc -l)

    # Calculate total available updates
    upd=$(( $pacman + $aur ))

    # Show tooltip
    if [ $upd -eq 0 ] ; then
        echo "{\"text\":\"$upd\", \"tooltip\":\"  Packages are up to date\"}"
    else
        echo "{\"text\":\"$upd\", \"tooltip\":\"󱓽 Official $pacman\n󱓾 AUR $aur\"}"
        # update_notification "$UPDATE_ICON" "Updates Available: $upd" "Main: $ofc\nAur: $aur"
    fi
}

package_update() {
    alacritty --title update -e "${UPDATE_SCRIPT}"
    check_for_updates() {
        aur=$(paru -Qua | wc -l)
        ofc=$(checkupdates | wc -l)

        # Calculate total available updates
        upd=$(( ofc + aur ))

        echo "$upd"
    }

    # tooltip in waybar
    aur=$(paru -Qua | wc -l)
    ofc=$(checkupdates | wc -l)

    # Initial check for updates
    upd=$(check_for_updates)

    sleep 1

    if [ $upd -eq 0 ]; then
        update_notification "$DONE_ICON" "Done" "Packages have been updated"
    elif [ $upd -gt 0 ]; then
        error_notification "$WARNING_ICON" "Warning!" "Some packages may have skipped"
    else
        error_notification "$ERROR_ICON" "Error!" "Sorry, could not update packages"
    fi

    "$SCRIPTS_DIR/waybar-reload.sh" --reload
}

case $1 in
    --check)
        check_update  # Check for available updates
        ;;
    --update)
        package_update  # Perform package update
        ;;
    *)
        echo "Invalid option. Use 'cu' to check for updates or 'up' to update packages."
        ;;
esac
