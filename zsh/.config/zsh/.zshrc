source "$ZDOTDIR/functions.zsh"

# Source files
zsh_add_file "aliases.zsh"
zsh_add_file "prompt.zsh"
zsh_add_file "vim-mode.zsh"
zsh_add_file "work.zsh"

# # Add plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# Other options
zle_highlight=("paste:none") # Don't highlight text on paste

# fnm node version manager
eval "$(fnm env --use-on-cd)"

# enable fzf bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



# Completions
autoload -Uz compinit
# zstyle ':completion:*' menu select
zstyle ':completion:*' menu yes select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.
