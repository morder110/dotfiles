# ~/.zsh/.zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

while read file
do 
  source "$ZDOTDIR/$file.zsh"
done <<-EOF
env
alias
opts
plugs
EOF
# utils - not included
# keys - not included
# prompt - not included

# source ~/.zsh/functions.zsh
# source ~/.zsh/functions.sh

# Create alias for commands with five underscors to remove them. Also, changes from snake_case to kebab-case.
# for fun in ${(ok)functions[(I)_____*]}; do
#   eval "alias ${${fun:5}//_/-}=\"${fun}\""
# done

zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
