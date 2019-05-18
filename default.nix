# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-19.03-2019-05-17";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-19.03-darwin`
    url = "https://github.com/nixos/nixpkgs/archive/c86f09d2d939f0f6993447117f841f19242500c2.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "0fvxn8w368wg8d0lgbmrkr3ws1i1484hjrzsr65y4wldz0w9chrq";
  }) {};

  pkgs-unstable = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-master-2019-05-17";
    url = "https://github.com/nixos/nixpkgs/archive/619492c03ecfc6cde541a680a1ac1e5250584acc.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "0ylk57v97mvzh37055my8z5marfcq7ircxjlnkqgg55y5xdcqzw1";
  }) {};

  hub = pkgs.gitAndTools.hub;

  lab = pkgs-unstable.gitAndTools.lab;

  custom = rec {
    inherit (pkgs) callPackage;

    ddgr = pkgs.ddgr;

    # Git with config baked in
    git = callPackage ./git {};

    pijul = callPackage ./pijul {
      pijul = pkgs.pijul;
    };

    pure-prompt = callPackage ./zsh/pure-prompt.nix {};

    # silver-searcher with environment setup
    silver-searcher = callPackage ./silver-searcher {};

    # Zsh with config baked in
    zsh = callPackage ./zsh {
      site-functions = builtins.map
        (p: "${p}/share/zsh/site-functions")
        [ ddgr pure-prompt hub lab pijul pkgs.nix-zsh-completions ];
    };

    # Tmux with a custom tmux.conf baked in
    tmux = callPackage ./tmux {
      reattach-to-user-namespace = if (pkgs.stdenv.isDarwin) then pkgs.reattach-to-user-namespace else null;
    };

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

  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  allPlatforms = with custom;
    [
      # Customized packages
      ddgr
      emacs
      fzf
      git
      #pijul
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
      lab
      pkgs.less
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.openjdk
      pinentry
      pkgs.tree
      pkgs.zsh-completions
    ];

  # The list of packages to be installed
  tools = allPlatforms;

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools; }
  else tools
