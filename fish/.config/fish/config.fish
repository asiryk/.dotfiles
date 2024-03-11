#
# In order to make it default shell on mac, add entry to /etc/shells
#

# Variables
set -x ZDOTDIR $HOME/.config/zsh
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x MANPAGER "nvim +Man!"
set -x EDITOR "nvim"
set -x NVIMDIR $HOME/.config/nvim
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -x GIT_DISCOVERY_ACROSS_FILESYSTEM 1

# Path
fish_add_path ~/bin
fish_add_path /opt/homebrew/bin
fish_add_path /Users/asiryk/Library/Python/3.9/bin
fish_add_path "/Applications/IntelliJ IDEA.app/Contents/MacOS"
fish_add_path $HOME/.cargo/bin

set -g fish_color_cwd cyan
set -g fish_color_command green
set -g fish_color_param white

# Programs
zoxide init fish | source
fnm env --use-on-cd | source

# Aliases
alias gs='git status'
alias ll='ls -al'
alias vim="nvim --noplugin"
alias vi="nvim --clean"
alias v="vi"

function fish_user_key_bindings
    # Enable vim mode
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

function fish_prompt --description 'minimum info snappy prompt'
    # Allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s%s%s %s%s%s\n%s\ue224\uf061%s ' \
            (set_color brblack) (date "+%H:%M:%S") (set_color normal) \
            (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) \
            (set_color bryellow) (set_color normal)
    else
        printf '%s%s%s %s%s%s\n\ue224\uf061 ' \
            (set_color brblack) (date "+%H:%M:%S") (set_color normal) \
            (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    end
end

function fish_mode_prompt --description 'set cursor style depending on vim mode'
    switch $fish_bind_mode
        case insert
            echo -n -e "\e[5 q"  # Beam Shape
        case default  # Normal mode falls under default
            echo -n -e "\e[2 q"  # Block Shape
        case visual
            echo -n -e "\e[2 q"  # Block Shape
        case replace_one
            echo -n -e "\e[4 q"  # Underscore Shape
    end
end
