<!-- markdownlint-disable MD013 MD007 -->
# Ascander's Dotfiles without Nix

If you're looking for the Nix-based system configuration, you want [ascander/dots](https://github.com/ascander/dots)

## Overview

This is a Nix-free version of my personal development environment for macOS machines. This includes:

- Homebrew for applications, packages, fonts, etc.
- Configuration for the tools I use (symlinked by [rcm](https://github.com/thoughtbot/rcm)) including:
    - Alacritty
    - Tmux
    - Karabiner Elements
    - ZSH

## Getting started

Do the following to set up a new macOS machine:

1. Install the Xcode command line tools.

```sh
xcode-select --install
```

2. [Generate SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
3. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

4. Install packages from Brewfile.

```sh
brew bundle --file ./Brewfile
```

5. Install `rcm` configuration file

```sh
rcup -d . rcrc
```

6. Install dotfiles

```sh
rcup
```

## Neovim

I'm trying out [LazyVim](https://lazyvim.github.io/) as an editor instead of a Nix-based configuration. You can find it at [ascander/nvim](https://github.com/ascander/nvim)
