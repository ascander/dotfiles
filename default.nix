# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-darwin-2019-02-16";
    url = https://github.com/nixos/nixpkgs/;
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-18.09-darwin`
    rev = "9bd45dddf8171e2fd4288d684f4f70a2025ded19";
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

    # Zsh with config baked in
    zsh = callPackage ./zsh {
      pure-prompt = callPackage ./zsh/pure-prompt.nix {};
    };

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

  darwinOnly = with pkgs; [
    reattach-to-user-namespace
  ];

  allPlatforms = with pkgs; with custom;
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
      gawk
      gitAndTools.hub
      gnupg
      less
      nix
      openjdk
      pinentry
      tree
      zsh-completions
    ];

  # The list of packages to be installed
  tools = with pkgs; with pkgs.lib;
    allPlatforms ++ optionals stdenv.isDarwin darwinOnly;

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools;
      shellHook = ''
        $(bashrc)
        '';
    }
  else tools
