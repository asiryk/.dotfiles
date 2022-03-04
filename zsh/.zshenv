export ZDOTDIR=$HOME/.config/zsh
export MANPAGER='nvim +Man!'
export EDITOR="nvim"
export NVIMDIR=$HOME/.config/nvim
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
. "$HOME/.cargo/env"
