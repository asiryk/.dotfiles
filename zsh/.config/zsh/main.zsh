export ZDOTDIR=$HOME/.config/zsh
source "$ZDOTDIR/functions.zsh"

# Source files
zsh_add_file "aliases.zsh"
zsh_add_file "prompt.zsh"

# Add plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Other options
zle_highlight=('paste:none')

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="alacritty"
export NVIMDIR=$HOME/.config/nvim
export JAVA_HOME=$(/usr/libexec/java_home)

# Load and init autocompletions
autoload compinit
compinit

# Add nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
