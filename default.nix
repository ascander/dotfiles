# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  nixpkgs-version = "18.09";
  pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-${nixpkgs-version}";
    url = "https://github.com/nixos/nixpkgs/archive/${nixpkgs-version}.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "1ib96has10v5nr6bzf7v8kw7yzww8zanxgw2qi1ll1sbv6kj6zpd";
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
      gnupg
      pinentry
      reattach-to-user-namespace
      zsh-completions
      gawk
      less
      nix
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
