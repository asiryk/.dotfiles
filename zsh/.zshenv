export ZDOTDIR=$HOME/.config/zsh
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export NVIMDIR=$HOME/.config/nvim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export GPG_TTY=$(tty) # without this git can not sign commits

export PATH="$PATH:$HOME/Personal/bin"
. "$HOME/.cargo/env"
