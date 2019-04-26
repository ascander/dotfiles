# my config files

## overview

This is my attempt at a [Nix](https://nixos.org/nix/) based dotfiles repository. Over time, I hope to migrate things to Nix, but for now, this will be a combination of things installed via Nix, and instructions for installing things manually. In particular, I manually install things like:

* Emacs
* GUI Apps (_eg._ Chrome)
* Fonts

## preliminaries

Instructions for a new machine are as follows:

1. Download and install the following apps:
   - [Google Chrome](https://www.google.com/chrome/)
   - [Google Drive Backup & Sync](https://www.google.com/drive/download/backup-and-sync/)
   - [Spotify Player](https://www.spotify.com/us/download/other/)
   - [Slack](https://slack.com/download)
   - [Karabiner Elements](https://pqrs.org/osx/karabiner/) (if on a Mac)
2. Download and install any fonts you might like (_eg._ [Iosevka](https://github.com/be5invis/Iosevka/releases/latest))
3. Generate SSH keys for Github/Github Enterprise/etc. See [these instructions](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) for how to do this.
4. If you have multiple keys for personal/work Github accounts, add a config file in `~/.ssh/config` along the following lines:

```sh
IgnoreUnknown UseKeychain

Host github.com
HostName github.com

Host <your github host>
HostName <your github host>
IdentityFile ~/.ssh/<your work key>

Host *
AddKeysToAgent yes
UseKeychain yes
IdentityFile ~/.ssh/<your personal key>
```

5. Install the Xcode command line developer tools:

``` sh
xcode-select --install
```

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
nix-shell -p git --run 'git clone https://github.com/ascander/dotfiles.git'
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

In Terminal settings, import `~/code/dotfiles/resources/settings.terminal` and make it the default profile.

## thanks

Thanks to the following people/repositories for inspiration, etc.

* @ceedubs for the [dotfiles](https://gitlab.com/ceedubs/dotfiles) repository, which is the basis for this one.
* @jwiegley for the [nix-config](https://github.com/jwiegley/nix-config) repository, which contains an excellent Nix-based config for Emacs
