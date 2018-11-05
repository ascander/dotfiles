# my config files

## setting up a new environment

### install nix

[Install Nix](https://nixos.org/nix/download.html) and then run this command to initialize it:

```sh
. $HOME/.nix-profile/etc/profile.d/nix.sh
```

### clone this repo and run the nix derivation

```sh
mkdir ~/code
cd code
nix-shell -p git --run 'git clone http://github.com/ceedubs/dotfiles'
nix-env -f dotfiles/default.nix -i --remove-all
```

### apply my preferred settings

```sh
. dotfiles/scripts/init_env.sh
```

### add zsh to the allowed shells and change to it

```sh
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells

chsh -s "$HOME/.nix-profile/bin/zsh"
```

### import terminal settings

In Terminal settings, import `~/code/dotfiles/resources/cody-mac-terminal-settings.terminal` and make it the default profile.

## thanks

Thank you and credit to @nmattia for [homies](https://github.com/nmattia/homies/blob/master/tmux/default.nix), which is the basis for the current form of this repository.
