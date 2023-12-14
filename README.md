# Ascander's Dotfiles without Nix

If you're looking for the Nix-based system configuration, you want [ascander/dots](https://github.com/ascander/dots)

## Overview

This is a Nix-free version of my personal development environment for macOS machines. This includes:

- Neovim, with a Lua-based config, and using [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- Homebrew for applications, packages, fonts, etc.
- Configuration for the tools I use (symlinked by [rcm](https://github.com/thoughtbot/rcm)) including:
    - Alacritty
    - Tmux
    - Karabiner Elements
    - ZSH

## TODO

- [x] Add packages to Brewfile
- [x] Add Neovim configuration
    - [x] add lazy.nvim support for plugins
    - [x] switch to mason for LSP configs/servers
- [x] Add Truecolor support for tmux + alacritty (tmux-256color terminal, alacritty TERMINFO)
- [ ] Add bootstrap script for installing Homebrew, etc.
- [ ] Add macOS defaults script
- [ ] Update dotfiles re: Nix-managed content
- [ ] Add zshrc file
- [ ] Figure out ZSH plugins (syntax highlighting, vi-mode, completions, etc.)
- [ ] Add local config settings (eg. `.zshrc.local`)
- [ ] Enable `focus-events` in tmux (`set-option -g focus-events on`)
- [ ] Add `jsonls` via `lspconfig` to keep `neoconf.nvim` happy
- [ ] Add `node` executable for nvim-treesitter to run `:TSInstallFromGrammar`
- [ ] Research Python/Ruby/Node.js/Perl provider(s) to see if they're needed; health warnings here
