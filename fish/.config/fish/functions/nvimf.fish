function nvimf --description="Open nvim straight into the Telescope file picker for the current dir"
    # Telescope loads on VeryLazy, which fires after `-c` commands run, so the
    # picker has to wait for that event instead of starting right away.
    nvim -c "autocmd User VeryLazy ++once lua require('telescope.builtin').find_files({ hidden = true })"
end
