function maccopy --description="Copy a file onto the macOS clipboard (paste into Finder, RDP, etc.)"
    if test (count $argv) -ne 1
        echo "usage: maccopy <file>" >&2
        return 1
    end

    if not test -e "$argv[1]"
        echo "maccopy: no such file: $argv[1]" >&2
        return 1
    end

    # Absolute path so Finder resolves it regardless of cwd.
    set -l target (realpath "$argv[1]")

    osascript -e "tell app \"Finder\" to set the clipboard to (POSIX file \"$target\")"
    and echo "Copied to clipboard: $target"
end
