function nvimh --description="Open nvim straight into the Gitl git-graph, full screen"
    # Gitl opens in a split, so the startup buffer would leave it at half
    # height; `only` closes everything else in the tab.
    nvim -c "Gitl $(_nvim_quote_args $argv)" -c only
end
