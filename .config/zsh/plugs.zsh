ZINIT_HOME="$HOME/.local/share/zsh/zinit"
if [ ! -d "$ZINIT_HOME" ]; then
  echo "ZINIT not found. Cloning..."
   mkdir -p "$(dirname $ZINIT_HOME)"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light Aloxaf/fzf-tab
# zinit light jeffreytse/zsh-vi-mode

zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# Fix PWD if Zinit changed it
zinit cdreplay -q
