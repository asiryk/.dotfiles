export ZDOTDIR=$HOME/.config/zsh
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export NVIMDIR=$HOME/.config/nvim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export GPG_TTY=$(tty) # without this git can not sign commits

export PATH="$PATH:$HOME/Personal/bin"
. "$HOME/.cargo/env"
