# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-2019-04-16";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-18.09-darwin`
    url = "https://github.com/nixos/nixpkgs/archive/feaf8ac4632c2d9d27f24272da2e6873d2e9a7ad.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "0qz8qmvh9vb6n1ziflhlww0pqqw936228pcpwnsyl8adi2izc7lw";
  }) {};

  unstable-pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-2019-04-16";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-unstable`
    url = "https://github.com/nixos/nixpkgs/archive/0c0954781e257b8b0dc49341795a2fe7d96945a3.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "05fq11wg8mik4zvfjy2gap59r8n0gfbklsw61r45wlqi7a2zsl0y";
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
      rev = "3cc020e384ce2a439813adb7a0cc772a034d90bb";
      sha256 = "0h2kzdfiw43rbiiffpqq9lkhvdv8mgzz2w29pzrxgv8d39x67vr9";
    }) {};

    vim = callPackage ./vim {
      inherit metals yarn2nix;
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
      pijul
      silver-searcher
      tmux
      vim
      zsh

      pkgs.bash
      pkgs.cacert
      pkgs.direnv
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
