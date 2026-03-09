#!/bin/bash

display() {
    cat << "EOF"
   ____         __              __  __        __     __
  / __/_ _____ / /____ __ _    / / / /__  ___/ /__ _/ /____
 _\ \/ // (_-</ __/ -_)  ' \  / /_/ / _ \/ _  / _ `/ __/ -_)
/___/\_, /___/\__/\__/_/_/_/  \____/ .__/\_,_/\_,_/\__/\__/
    /___/                         /_/

EOF
}

display
printf "\n"

choice=$(gum confirm "Would you like to," \
        --prompt.foreground "#eabbd1" \
        --affirmative "Update" \
        --selected.background "#eabbd1" \
        --selected.foreground "#09080A" \
        --negative "Cancel"
        )

if [ $? -eq 0 ]; then
    # updating the system
    paru -Syyu --noconfirm
    flatpak update -y

    sleep 1

    printf "\n\n<>Press ENTER to close "
    read
else
    gum spin \
        --spinner dot \
        --spinner.foreground "#eabbd1" \
        --title "Skipping updating your system..." -- \
        sleep 2
fi
