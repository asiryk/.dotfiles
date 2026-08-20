function _nvim_quote_args --description="Re-quote shell args for an ex command line (Gitl/DiffviewOpen)"
    # The ex command line is one string, so args that contain spaces
    # (`--grep "some text"`) need their quotes back for nvim to re-split them.
    set -l out
    for arg in $argv
        if string match -q -- '* *' $arg
            set -a out "'$arg'"
        else
            set -a out $arg
        end
    end
    string join -- ' ' $out
end
