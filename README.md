# dotfiles repo

## A list of installed programs

The configuration for some of these programs are present in this repo

* [Alacritty](https://github.com/alacritty/alacritty) - A cross-platform, OpenGL terminal emulator
* [bat](https://github.com/sharkdp/bat) - A cat(1) clone with wings
* [delta](https://github.com/dandavison/delta) - A syntax-highlighting pager for git, diff, and grep output
* [exa](https://github.com/ogham/exa) - A modern replacement for 'ls'
* [fd](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to 'find'
* [fnm](https://github.com/Schniz/fnm) - Fast and simple Node.js version manager, built in Rust
* [hyperfine](https://github.com/sharkdp/hyperfine) - A command-line benchmarking tool
* [Neovim](https://github.com/neovim/neovim) - Vim-fork focused on extensibility and usability
* [ripgrep](https://github.com/BurntSushi/ripgrep) - ripgrep recursively searches directories for a regex pattern while respecting your gitignore
* [stow](https://www.gnu.org/software/stow) - A symlink farm manager

## Usage with GNU Stow

To create a symlink for a specific program's config, e.g. zsh use

```bash
stow zsh # This will create a symlink to contents of zsh directory
```
