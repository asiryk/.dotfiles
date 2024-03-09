function fish_user_key_bindings
    # Enable vim mode
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    theme_colors
end

function fish_prompt --description 'minimum info snappy prompt'
    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s%s%s %s%s%s\n%s\ue224\uf061%s ' \
            (set_color brblack) (date "+%H:%M:%S") (set_color normal) \
            (set_color $fish_color_cwd) $PWD (set_color normal) \
            (set_color bryellow) (set_color normal)
    else
        printf '%s%s%s %s%s%s\n\ue224\uf061 ' \
            (set_color brblack) (date "+%H:%M:%S") (set_color normal) \
            (set_color $fish_color_cwd) $PWD (set_color normal)
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

function theme_colors --description 'set custome theme colors'
    set -g fish_color_cwd cyan
    set -g fish_color_command green
    set -g fish_color_param white
end
