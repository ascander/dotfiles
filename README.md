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

1. [Generate SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
1. Run the bootstrap script

    ```sh
    ./bin/bootstrap.sh
    ```

1. Install packages from the Brewfile

    ```sh
    brew bundle --file ./Brewfile
    ```

1. Install `rcm` configuration file

    ```sh
    rcup -d . rcrc
    ```

1. Install dotfiles

    ```sh
    rcup
    ```

1. Set up macOS defaults

    ```sh
    ./bin/defaults.sh
    ```

## Neovim

I'm trying out [LazyVim](https://lazyvim.github.io/) as an editor instead of a Nix-based configuration. You can find it at [ascander/nvim](https://github.com/ascander/nvim)

## Alacritty Themes

I've included a number of Alacritty themes in [config/alacritty/themes](./config/alacritty/themes/) as well as a theme switcher script in [bin/switchtheme.sh](./bin/switchtheme.sh). You can switch to eg. [nightfox](https://github.com/EdenEast/nightfox.nvim) as follows:

```sh
./bin/switchtheme.sh nightfox
```

## GPG

Setting up [GPG](https://www.gnupg.org/) for signed commits to Github requires Homebrew dependencies to be installed, viz. `gnupg` and `pinentry-mac`. I currently set this up manually, following [this gist](https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e#file-2-using-gpg-md).

## Local

My convention for local configuration (ie., packages and/or configuration you need on a work computer) is to use file(s) ending in `.local` including:

- `Brewfile.local` for Homebrew packages
- `zshrc.local` for ZSH settings/env/etc.
