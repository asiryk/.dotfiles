function fish_user_key_bindings
    # Enable vim mode
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

function fish_mode_prompt
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
