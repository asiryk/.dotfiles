function nvimd --description="Open nvim straight into Diffview (nvimd, nvimd main..HEAD, ...)"
    nvim -c "DiffviewOpen $(_nvim_quote_args $argv)"
end
