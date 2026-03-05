function tmux_pick_session
  set session (tmux list-sessions -F '#{session_name}' | sort | fzf --prompt='Select session: ')
  if test -n "$session"
    tmux switch-client -t $session
  end
end
