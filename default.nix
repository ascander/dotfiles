# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-darwin-2019-02-08";
    url = https://github.com/nixos/nixpkgs/;
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-18.09-darwin`
    rev = "13050bedc49f89ab76a5f72a7c90b4c3af39514e";
    ref = "release-18.09";
  }) {};

  custom = rec {
    # A custom '.bashrc' (see bashrc/default.nix for details)
    bashrc = pkgs.callPackage ./bashrc {};

    # Git with config baked in
    git = import ./git (
      { inherit (pkgs) makeWrapper symlinkJoin;
        git = pkgs.git;
      });

    # silver-searcher with environment setup
    silver-searcher = import ./silver-searcher (
      { inherit (pkgs) makeWrapper symlinkJoin;
        silver-searcher = pkgs.silver-searcher;
      });

    # custom prezto
    zsh-prezto = import ./zsh/prezto.nix (
      { inherit (pkgs) stdenv fetchgit; }
    );

    # Zsh with config baked in
    zsh = import ./zsh (
      { inherit (pkgs) makeWrapper symlinkJoin;
        zsh = pkgs.zsh;
        zsh-prezto = zsh-prezto;
      });

    # Tmux with a custom tmux.conf baked in
    tmux = import ./tmux (with pkgs;
      { inherit
          makeWrapper
          symlinkJoin
          ;
        tmux = pkgs.tmux;
      });

    vim = import ./vim (
      {
        neovim = pkgs.neovim;
        vimPlugins = pkgs.vimPlugins;
        buildVimPluginFrom2Nix = pkgs.vimUtils.buildVimPluginFrom2Nix;
        fetchFromGitHub = pkgs.fetchFromGitHub;
      });

    emacs = import ./emacs (with pkgs;
      { inherit
          makeWrapper
          symlinkJoin
        ;
        emacsWithPackages = (pkgs.emacsPackagesNgGen pkgs.emacs).emacsWithPackages;
        epkgs = pkgs.epkgs.melpaStablePackages;
      });

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

  ## Some customizations

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools;
      shellHook = ''
        $(bashrc)
        '';
    }
  else tools
