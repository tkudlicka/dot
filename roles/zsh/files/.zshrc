export ZSH="$HOME/.oh-my-zsh"

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zhistory"
HISTSIZE=100000
SAVEHIST=50000
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Alias nvim
if command -v nvim >/dev/null 2>&1; then
  alias vim=nvim
  alias vimdiff='nvim -d'
fi

export PATH="/opt/homebrew/bin:$PATH"

export PATH=$(brew --prefix)/bin:$PATH
plugins=(git z brew shrink-path aliases ansible)
source $ZSH/oh-my-zsh.sh
source ~/.config/zsh/.zsh_profile
# pnpm
export PNPM_HOME="/home/tomaskudlicka/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# Set git alias prefix
zstyle ':zim:git' aliases-prefix g

# Enable colors for ls
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

