export ZDOTDIR=$HOME/.config/zsh
source "$ZDOTDIR/functions.zsh"

# Source files
zsh_add_file "aliases.zsh"
zsh_add_file "prompt.zsh"
zsh_add_file "work.zsh"

# Add plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Other options
zle_highlight=('paste:none') # Don't highlight text on paste

# Load and init autocompletions
autoload compinit
compinit

export MANPAGER='nvim +Man!'

# Environment variables set everywhere
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export EDITOR="nvim"
export NVIMDIR=$HOME/.config/nvim
