export ZDOTDIR=$HOME/.config/zsh
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export NVIMDIR=$HOME/.config/nvim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# export GPG_TTY=$(tty) # without this git can not sign commits
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

export PATH="$PATH:$HOME/Personal/bin"
export PATH="$PATH:$HOME/tomcat/apache-tomcat-10.1.13/bin"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/Users/asiryk/Library/Python/3.9/bin"
export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"
. "$HOME/.cargo/env"

export JAVA_HOME="/Users/asiryk/Library/Java/JavaVirtualMachines/openjdk-21/Contents/Home"
export "PATH=$JAVA_HOME/bin:$PATH"
