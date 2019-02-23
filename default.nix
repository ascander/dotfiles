# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-2019-02-20";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-18.09-darwin`
    url = "https://github.com/nixos/nixpkgs/archive/19a0543c62847c6677c2563fc8c986c1c82f2ea3.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "13ndciddbqi5j6b5pajyx476aq5idpk4jsjaiw76y7ygnqj3y239";
  }) {};

  hub = pkgs.gitAndTools.hub;

  custom = rec {
    inherit (pkgs) callPackage;

    # A custom '.bashrc' (see bashrc/default.nix for details)
    bashrc = callPackage ./bashrc {};

    ddgr = callPackage ./ddgr {};

    # Git with config baked in
    git = callPackage ./git {};

    # silver-searcher with environment setup
    silver-searcher = callPackage ./silver-searcher {};

    pure-prompt = callPackage ./zsh/pure-prompt.nix {};

    # Zsh with config baked in
    zsh = callPackage ./zsh {
      site-functions = [
        "${ddgr}/share/zsh/site-functions"
        "${pure-prompt}/share/zsh/site-functions"
        "${hub}/share/zsh/site-functions"
      ];
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
      ddgr
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
      hub
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
