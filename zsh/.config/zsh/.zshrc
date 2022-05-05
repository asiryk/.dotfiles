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

# fnm node version manager
eval "$(fnm env --use-on-cd)"
