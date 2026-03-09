#!/bin/bash
HYPR_DIR="$HOME/.config/hypr"
PROFILES_DIR="$HYPR_DIR/config/monitors"
SCRIPTS_DIR="$HOME/.assets/scripts"
TEMP_DIR="$(mktemp -d)"

LOADED_PROFILE_NAME=""
MANUAL_OPTION_TYPE="new"

function profile-name {
    # Prompt user for profile name.
    while true; do
        # TODO: List all profile names.
        # TODO: Ensure gum error message is actually displayed.
        # ls -g
        local profile_name=$(gum input --placeholder "unique-profile-name" --header "Enter a unique name for this new profile:")
        if [ -z "$profile_name" ]; then
            gum style --foreground 1 "[ERROR] Please provide a profile name."
            continue
        fi

        # Sanitize the profile name to be filename-safe. Use hyphen (-) where unsafe characters.
        local safe_profile_name=$(echo "$profile_name" | sed 's/[^a-zA-Z0-9_-]/-/g')
        if [ -d "$PROFILES_DIR/$safe_profile_name" ]; then
            gum style --foreground 1 "[ERROR] Profile '$safe_profile_name' already exists. Choose a different name."
            continue
        fi

        # TODO: Fix this returning string from error messages as well. Should only return this string.
        echo $safe_profile_name
        break
    done
}

function manual-setup {
    # Open nwg-displays and wait for config files
    while true; do
        gum spin --spinner dot --title "Starting nwg-displays and waiting for configuration ..." -- nwg-displays -m "$TEMP_DIR/monitors.conf" -w "$TEMP_DIR/workspaces.conf"

        if [ ! -f "$TEMP_DIR/monitors.conf" ]; then
            gum style --foreground 1 "[ERROR] Configurations not saved. Please try again."

            sleep 2
            continue
        fi

        break
    done

    # Remove empty files spawned by nwg displays.
    rm $HYPR_DIR/monitors.conf
    rm $HYPR_DIR/workspaces.conf

    local profile_name=$(profile-name)

    gum style --foreground 2 "[+] Creating profile '${profile_name}'"

    # Create profile folder and add files.
    local new_profile_dir="$PROFILES_DIR/$profile_name"
    mkdir -p $new_profile_dir
    mv "$TEMP_DIR/variables.conf" "$new_profile_dir/variables.conf"
    mv "$TEMP_DIR/monitors.conf" "$new_profile_dir/monitors.conf"

    # Workspaces is optinal to configure. If not configured, use an empty file.
    if [ -f "$TEMP_DIR/workspaces.conf" ]; then
        mv "$TEMP_DIR/workspaces.conf" "$new_profile_dir/workspaces.conf"
    else
        touch "$new_profile_dir/workspaces.conf"
    fi

    gum style --foreground 2 "[+] Created configuration files"

    # Save active monitors for use in `monitor_profile.sh`
    hyprctl monitors | grep 'model:' | sed 's/^[ \t]*model:[ \t]*//' | sort | tee > $new_profile_dir/.monitor-combination

    ln -sfn "$new_profile_dir" "$PROFILES_DIR/active"
    gum style --foreground 2 "[+] Updated active monitor symlink"

    gum spin --spinner dot --title "Reloading Hyprland..." -- hyprctl reload
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "Profile '$profile_name' has been created and applied."

    gum confirm "Would you like to update the variables now?" && nano $new_profile_dir/variables.conf
}

function auto-setup {
    local profile_name=$(profile-name)
    local new_profile_dir="$PROFILES_DIR/$profile_name"

    mkdir $new_profile_dir
    touch "$new_profile_dir/monitors.conf"
    touch "$new_profile_dir/workspaces.conf"
    cp "$PROFILES_DIR/.variables-template.conf" "$new_profile_dir/variables.conf"
    touch "$new_profile_dir/.monitor-combination"

    local monitor_info=$(hyprctl monitors)
    local connected_monitors_models=$(hyprctl monitors | grep 'model:' | sed 's/^[ \t]*model:[ \t]*//' | sort)

    local is_first_monitor=true
    local x=0
    hyprctl monitors -j | jq -c '.[]' | while read -r monitor_json; do
        local monitor_port=$(echo "$monitor_json" | jq -r '.name')
        local monitor_name=$(echo "$monitor_json" | jq -r '.model')
        local width=$(echo "$monitor_json" | jq -r '.width')
        local height=$(echo "$monitor_json" | jq -r '.height')
        local refresh_rate=$(printf "%.2f" "$(echo "$monitor_json" | jq -r '.refreshRate')")

        if [ "$is_first_monitor" = true ]; then
            aspect_ratio=$(sh $SCRIPTS_DIR/bash/utilities/get-aspect-ratio.sh "${width}x${height}")
            sed -i "s|^\$primary_monitor = .*|\$primary_monitor = $monitor_port|" "$new_profile_dir/variables.conf"
            sed -i "s|^\$primary_monitor_aspect_ratio = .*|\$primary_monitor_aspect_ratio = $aspect_ratio|" "$new_profile_dir/variables.conf"
            is_first_monitor=false
        fi

        echo "$monitor_name" >> "$new_profile_dir/.monitor-combination"
        echo "monitor=${monitor_port},${width}x${height}@${refresh_rate},${x}x0,1.0" >> "$new_profile_dir/monitors.conf"

        (( x += width ))
    done

    gum confirm "Would you like to update the variables now?" && nano $new_profile_dir/variables.conf
}

while true; do
    clear

    # Remove files form previous run and prepare for current
    rm -rf "$TEMP_DIR" &>/dev/null
    mkdir -p "$TEMP_DIR" &>/dev/null
    cp "$PROFILES_DIR/.variables-template.conf" "$TEMP_DIR/variables.conf"  &>/dev/null

    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Monitor Setup wizard" "\"The wizard will now configure your monitors"\"

    # Display which profile will be used as template if selected.
    if [ -n "$LOADED_PROFILE_NAME" ]; then
        cp "$PROFILES_DIR/$LOADED_PROFILE_NAME"/* "$TEMP_DIR/"
        gum style --foreground 2 "[+] Loaded profile '$LOADED_PROFILE_NAME'"
    fi

    CHOICE=$(gum choose "Manual setup ($MANUAL_OPTION_TYPE)" "Auto setup" "From profile" --header "Select a monitor configuration method:")

    case "$CHOICE" in
        "Manual setup (new)"|"Manual setup (from profile)")
            manual-setup
            break
            ;;

        "Auto setup")
            auto-setup
            break
            ;;

        "From profile")
            PROFILES=$(find "$PROFILES_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")

            if [ -z "$PROFILES" ]; then
                gum style --foreground 3 "No profiles found to load."
                sleep 1
                continue
            fi

            SELECTED_PROFILE_NAME=$(echo "$PROFILES" | gum choose --header "Select a profile to load for editing")

            if [ -z "$SELECTED_PROFILE_NAME" ] || [ "$SELECTED_PROFILE_NAME" == "nothing selected" ]; then
                LOADED_PROFILE_NAME=""
                MANUAL_OPTION_TYPE="new"
            else
                LOADED_PROFILE_NAME="$SELECTED_PROFILE_NAME"
                MANUAL_OPTION_TYPE="from profile"
            fi

            ;;

        *)
            gum style --foreground "red" "Some idiot did not implement this feature"
            exit 1
            ;;
    esac
done

rm -rf $TEMP_DIR

hyprctl reload