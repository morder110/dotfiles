bindkey -M emacs '^[[1;5C' forward-word # Ctrl + Right
bindkey -M emacs '^[[1;5D' backward-word # Ctrl + Left
bindkey -M emacs '^H' backward-kill-word # Ctrl + Backspace
bindkey -M emacs '^[[3~' delete-char # Delete
bindkey -M emacs '^[[3;5~' kill-word # Ctrl + Delete
bindkey -M emacs '^[[H' beginning-of-line # Home
bindkey -M emacs '^[[F' end-of-line # End

# # fastfetch
# if command -v fastfetch &> /dev/null; then
#     # Only run fastfetch if we're in an interactive shell
#     if [[ $- == *i* ]]; then
#         if [[ -d "$HOME/.local/share/fastfetch" ]]; then
#             ffconfig=ascii-art
#             # fastfetch --config "$ffconfig"
#             alias fastfetch='clr && fastfetch --config $ffconfig'
#         else
#             # fastfetch
#         fi
#     fi
# fi

# fcd - cd into the directory of the selected file
fcd() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# Search and install package (pacman) using fzf
function fpacmani() {
    pacman -Slq | fzf -q "$1" -m --preview 'pacman -Si {1}'| cut -d " " -f1 | xargs -ro sudo pacman -S
}

# Search and remove package (pacman) using fzf
function fpacmanr() {
    pacman -Qq | fzf -q "$1" -m --preview 'pacman -Qi {1}' | cut -d " " -f1 | xargs -ro sudo pacman -Rns
}

# Search installed packages (pacman) using fzf
function fpacmanq() {
    pacman -Qq | fzf -q "$1" -m --preview 'pacman -Qi {1}'
}

# Search user installed packages (pacman) using fzf
function fpacmanqu() {
    comm -23 \
        <(pacman -Qqett | sort) \
        <(expac -l '\n' '%E' base-devel | sort) \
        | fzf -q "$1" -m --preview 'pacman -Qi {1}'
}

# Search and install package (paru) using fzf
function fparui() {
    paru -Slq | fzf -q "$1" -m --preview 'paru -Si {1}'| cut -d " " -f1 | xargs -ro paru -S
}

# Search and remove package (paru) using fzf
function fparur() {
    paru -Qm | fzf -q "$1" -m --preview 'paru -Qi {1}' | cut -d " " -f1 | xargs -ro paru -Rns
}

# Search installed AUR packages using fzf
function fparuq() {
    paru -Qm | fzf -q "$1" -m --preview 'paru -Qi {}'
}

function fauri() {
    fparui "$@"
}

function faurr() {
    fparur "$@"
}

function faurq() {
    fparuq "$@"
}

# Docker
# Select a docker container to start and attach to
# function da() {
#   local cid
#   cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

#   [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
# }

# # Select a running docker container to stop
# function ds() {
#   local cid
#   cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

#   [ -n "$cid" ] && docker stop "$cid"
# }

# # Select a docker container to remove. Allows multi selection
# function drm() {
#   docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
# }

# # Select a docker image or images to remove
# function drmi() {
#   docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
# }


# TODO: Check and test this: 
# # CLR=$(for i in {0..7}; do echo "tput setaf $i"; done)
# BLK=\$(tput setaf 0); RED=\$(tput setaf 1); GRN=\$(tput setaf 2); YLW=\$(tput setaf 3); BLU=\$(tput setaf 4); 
# MGN=\$(tput setaf 5); CYN=\$(tput setaf 6); WHT=\$(tput setaf 7); BLD=\$(tput bold); RST=\$(tput sgr0);    

# AWK_VAR="awk -v BLK=${BLK} -v RED=${RED} -v GRN=${GRN} -v YLW=${YLW} -v BLU=${BLU} -v MGN=${MGN} -v CYN=${CYN} -v WHT=${WHT} -v BLD=${BLD} -v RST=${RST}"

# # Searches only from flathub repository
# fzf-flatpak-install-widget() {
#   flatpak remote-ls flathub --cached --columns=app,name,description \
#   | awk -v cyn=$(tput setaf 6) -v blu=$(tput setaf 4) -v bld=$(tput bold) -v res=$(tput sgr0) \
#   '{
#     app_info=""; 
#     for(i=2;i<=NF;i++){
#       app_info=cyn app_info" "$i 
#     };
#     print blu bld $2" -" res app_info "|" $1
#     }' \
#   | column -t -s "|" -R0 \
#   | fzf \
#     --ansi \
#     --with-nth=1.. \
#     --prompt="Install > " \
#     --preview-window "nohidden,40%,<50(down,50%,border-rounded)" \
#     --preview "flatpak --system remote-info flathub {-1} | $AWK_VAR -F\":\" '{print YLW BLD \$1 RST WHT \$2}'" \
#     --bind "enter:execute(flatpak install flathub {-1})" # when pressed enter it doesn't showing the key pressed but it is reading the input
#   zle reset-prompt
# }
# bindkey '^[f^[i' fzf-flatpak-install-widget #alt-f + alt-i
# zle -N fzf-flatpak-install-widget

# fzf-flatpak-uninstall-widget() {
#   touch /tmp/uns
#   flatpak list --columns=application,name \
#   | awk -v cyn=$(tput setaf 6) -v blu=$(tput setaf 4) -v bld=$(tput bold) -v res=$(tput sgr0)  \
#   '{
#     app_id="";
#     for(i=2;i<=NF;i++){
#       app_id" "$i
#     };
#     print bld cyn $2 " - " res blu $1
#    }' \
#   | column -t \
#   | fzf \
#     --ansi \
#     --with-nth=1.. \
#     --prompt="  Uninstall > " \
#     --header="M-u: Uninstall | M-r: Run" \
#     --header-first \
#     --preview-window "nohidden,50%,<50(up,50%,border-rounded)" \
#     --preview  "flatpak info {3} | $AWK_VAR -F\":\" '{print RED BLD  \$1 RST \$2}'" \
#     --bind "alt-r:change-prompt(Run > )+execute-silent(touch /tmp/run && rm -r /tmp/uns)" \
#     --bind "alt-u:change-prompt(Uninstall > )+execute-silent(touch /tmp/uns && rm -r /tmp/run)" \
#     --bind "enter:execute(
#     if [ -f /tmp/uns ]; then 
#       flatpak uninstall {3}; 
#     elif [ -f /tmp/run ]; then
#       flatpak run {3}; 
#     fi
#     )" # same as the install one but when pressed  entered the message is something like this 
# # "Proceed with these changes to the system installation? [Y/n]:" but it will uninstall the selected app weird but idk y
#   rm -f /tmp/{uns,run} &> /dev/null
#   zle reset-prompt
# }
# bindkey '^[f^[u' fzf-flatpak-uninstall-widget #alt-f + alt-u
# zle -N fzf-flatpak-uninstall-widget

alias aur="paru"
alias cls="clear"
alias sl="ls"
alias ls="exa"
alias ll="exa -alh"
alias lll="exa -alh --total-size"
alias tree="exa --tree"
alias llblk="lsblk -l -o NAME,FSTYPE,SIZE,LABEL,MOUNTPOINTS,UUID"