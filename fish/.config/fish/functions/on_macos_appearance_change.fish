# A hook that can be called when macos changes appearance
# It can be called by automator or some other thing that
# is able to notice theme change.
function on_macos_appearance_change
  # Reload config (it handles theme change)
  tmux source-file ~/.config/tmux/tmux.conf
end
