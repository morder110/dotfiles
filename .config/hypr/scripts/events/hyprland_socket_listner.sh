#!/bin/sh

# TODO: Create this in compiled language. Also, this is where you add the stuff for connecting monitors.
handle() {
  case $1 in
    # monitoradded*) do_something ;;
    openwindow*)
        if [[ $1 == *"jetbrains-"* ]]; then
          WINDOW_ADDRESS=0x$(echo "$1" | cut -d '>' -f3 | cut -d ',' -f1)
          # Give the window a moment to spawn properly
          sleep 0.4

          if [[ $1 == *"Welcome to "* ]]; then
            hyprctl dispatch resizewindowpixel exact 600 450,address:$WINDOW_ADDRESS 1>/dev/null
            hyprctl dispatch centerwindow address:$WINDOW_ADDRESS 1>/dev/null
          elif [[ $1 == *"Toolbox"* ]]; then
            hyprctl dispatch centerwindow address:$WINDOW_ADDRESS 1>/dev/null
          elif [[ $1 == *"Keyboard Shortcut"* ]]; then
            hyprctl dispatch resizewindowpixel exact 400 250,address:$WINDOW_ADDRESS 1>/dev/null
          fi
        fi
        ;;
    urgent*)
        WINDOW_ADDRESS=0x$(echo "$1" | cut -d '>' -f3 | cut -d ',' -f1)
        read -r CLASS WORKSPACE_NAME < <(hyprctl clients -j | jq -r --arg addr "$WINDOW_ADDRESS" '.[] | select(.address == $addr) | .class, .workspace.name') 1>/dev/null

        if [[ $CLASS == "vesktop" ]]; then
            $(hyprctl -j activeworkspace | jq ".id == 10") || hyprctl dispatch workspace 10 1>/dev/null
        fi
        ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done