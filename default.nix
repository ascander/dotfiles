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

  unstable-pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-2019-02-23";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-unstable`
    url = "https://github.com/nixos/nixpkgs/archive/44f78998bbbf7fdf1262442ca9f3f7db11ae2516.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "1iflrjf2hcc96q5cw70xjkq8cw98r69yihhgw52bc2s7ryx4f1ky";
  }) {};

  hub = pkgs.gitAndTools.hub;

  custom = rec {
    inherit (pkgs) callPackage;

    ddgr = unstable-pkgs.ddgr;

    # Git with config baked in
    git = callPackage ./git {};

    pijul = callPackage ./pijul {
      pijul = unstable-pkgs.pijul;
    };

    pure-prompt = callPackage ./zsh/pure-prompt.nix {};

    # silver-searcher with environment setup
    silver-searcher = callPackage ./silver-searcher {};

    # Zsh with config baked in
    zsh = callPackage ./zsh {
      site-functions = builtins.map
        (p: "${p}/share/zsh/site-functions")
        [ ddgr pure-prompt hub pijul pkgs.nix-zsh-completions ];
    };

    # Tmux with a custom tmux.conf baked in
    tmux = callPackage ./tmux {};

    emacs = callPackage ./emacs {
      emacsWithPackages = (pkgs.emacsPackagesNgGen pkgs.emacs).emacsWithPackages;
      epkgs = pkgs.epkgs.melpaStablePackages;
    };

    metals = pkgs.callPackage ./metals {};

    fzf = pkgs.callPackage ./fzf {};

    yarn2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "moretea";
      repo = "yarn2nix";
      rev = "780e33a07fd821e09ab5b05223ddb4ca15ac663f";
      sha256 = "1f83cr9qgk95g3571ps644rvgfzv2i4i7532q8pg405s4q5ada3h";
    }) {};

    vim = callPackage ./vim {
      inherit yarn2nix;
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    };
  };

  darwinOnly = with pkgs; [
    reattach-to-user-namespace
  ];

  allPlatforms = with custom;
    [
      # Customized packages
      ddgr
      emacs
      fzf
      git
      metals
      pijul
      silver-searcher
      tmux
      vim
      zsh

      pkgs.bash
      pkgs.cacert
      pkgs.gawk
      pkgs.gnupg
      hub
      pkgs.less
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.openjdk
      pkgs.pinentry
      pkgs.tree
      pkgs.zsh-completions
    ];

  # The list of packages to be installed
  tools = with pkgs; with pkgs.lib;
    allPlatforms ++ optionals stdenv.isDarwin darwinOnly;

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools; }
  else tools
