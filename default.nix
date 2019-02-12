# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-darwin-2019-02-11";
    url = https://github.com/nixos/nixpkgs/;
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-18.09-darwin`
    rev = "168cbb39691cca2822ce1fdb3e8c0183af5c6d0d";
    ref = "release-18.09";
  }) {};

  custom = rec {
    inherit (pkgs) callPackage;

    # A custom '.bashrc' (see bashrc/default.nix for details)
    bashrc = callPackage ./bashrc {};

    # Git with config baked in
    git = callPackage ./git {};

    # silver-searcher with environment setup
    silver-searcher = callPackage ./silver-searcher {};

    # custom prezto
    zsh-prezto = callPackage ./zsh/prezto.nix {};

    # Zsh with config baked in
    zsh = callPackage ./zsh { inherit zsh-prezto; };

    # Tmux with a custom tmux.conf baked in
    tmux = callPackage ./tmux {};

    vim = callPackage ./vim {
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    };

    emacs = callPackage ./emacs {
      emacsWithPackages = (pkgs.emacsPackagesNgGen pkgs.emacs).emacsWithPackages;
      epkgs = pkgs.epkgs.melpaStablePackages;
    };

    metals = pkgs.callPackage ./metals {};

    fzf = pkgs.callPackage ./fzf {};
  };

  # The list of packages to be installed
  tools = with pkgs; with custom;
    [
      # Customized packages
      bashrc
      git
      tmux
      vim
      zsh
      silver-searcher
      emacs
      metals

      bash
      cacert
      fzf
      gnupg
      pinentry
      reattach-to-user-namespace
      zsh-completions
      gawk
      less
      nix
      sbt
      tree
      gitAndTools.hub
      openjdk
    ];

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools;
      shellHook = ''
        $(bashrc)
        '';
    }
  else tools
