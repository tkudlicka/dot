# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#export PATH=/usr/local/share/npm/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH="/opt/homebrew/bin:$PATH"

export PATH=$(brew --prefix)/bin:$PATH
plugins=(git z brew 1password aliases ansible shrink-path)
source $ZSH/oh-my-zsh.sh
source ~/.config/zsh/.zsh_profile
# pnpm
export PNPM_HOME="/home/tomaskudlicka/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
#
# nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
# NODE_DEFAULT_PATH="${NVM_DIR}/versions/default/bin"
# PATH="${NODE_DEFAULT_PATH}:${PATH}"
# switchNode() {
#   local NODE_PATH TARGET_NODE_VERSION
#   if [ -f '.nvmrc' ]; then
#     TARGET_NODE_VERSION="$(nvm version $(cat .nvmrc))"
#     NODE_PATH="${NVM_DIR}/versions/node/${TARGET_NODE_VERSION}/bin"
#   else
#     TARGET_NODE_VERSION="$(nvm version default)"
#     NODE_PATH="${NODE_DEFAULT_PATH}"
#   fi
#   if [ "${TARGET_NODE_VERSION}" != "$(nvm current)" ]; then
#     PATH="${NODE_PATH}:${PATH}"
#   fi
# }

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
