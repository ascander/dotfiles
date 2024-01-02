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

1. [Generate SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) (ie. for Github access)
1. Run the bootstrap script

    ```sh
    ./bootstrap.sh
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
    ./defaults.sh
    ```

## Neovim

I'm trying out [LazyVim](https://lazyvim.github.io/) as an editor instead of a Nix-based configuration. You can find it at [ascander/nvim](https://github.com/ascander/nvim)

## Local

My convention for local configuration (ie., packages and/or configuration you need on a work computer) is to use file(s) ending in `.local` including:

- `Brewfile.local` for Homebrew packages
- `zshrc.local` for ZSH settings/env/etc.
