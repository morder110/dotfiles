umask 022 # Permissions
zmodload zsh/zle
zmodload zsh/zpty
zmodload zsh/complist

# TODO: Test these
# Original
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# zstyle ':completion:*' matcher-list '' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# zstyle ':completion:*' menu select=long
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# zstyle ':completion:*' completer _complete _ignored _approximate
zstyle :compinstall filename '/home/morder/.config/zsh/.zshrc'

# Other
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview $realpath'
# zstyle ':fzf-tab:*' switch-group ',' '.'
# zstyle ':fzf-tab:*' fzf-min-height 100

# History file
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
HISTORY_IGNORE="(echo *|printf *|print *|ls)"
SAVEHIST=$HISTSIZE
HISTDUP=erase

ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$color8,bold"

# Included options
while read -r option
do
  setopt $option
done <<-EOF 
AUTOCD
AUTO_MENU
AUTO_PARAM_SLASH
ALWAYS_TO_END
NOTIFY
NOHUP
INTERACTIVE_COMMENTS
NO_MENU_COMPLETE
NUMERIC_GLOB_SORT
PROMPTSUBST
APPEND_HISTORY
SHARE_HISTORY
INC_APPEND_HISTORY
EXTENDED_HISTORY
HIST_IGNORE_ALL_DUPS
HIST_IGNORE_SPACE
HIST_NO_FUNCTIONS
HIST_EXPIRE_DUPS_FIRST
HIST_SAVE_NO_DUPS
HIST_REDUCE_BLANKS
EOF

# Excluded options
while read -r option
do
  unsetopt $option
done <<-EOF 
CORRECT
NOMATCH
FLOW_CONTROL
EOF

bindkey -e # revert to emacs binds instead of vi-mode

# Tracker for cd commands to rank most used folders.
[[ $(command -v zoxide) ]] && eval "$(zoxide init zsh)"

eval "$(fzf --zsh)" # fzf