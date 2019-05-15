# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  # use a pinned version of nixpkgs for reproducability
  pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-18.09-2019-05-14";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-18.09-darwin`
    url = "https://github.com/nixos/nixpkgs/archive/1e9e709953e315ab004951248b186ac8e2306451.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "0vimw4pqiqiz23hnpbcir413n4mbmz8bpq430w7d234mpzws48w7";
  }) {};

  unstable-pkgs = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-unstable-2019-05-14";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-unstable`
    url = "https://github.com/nixos/nixpkgs/archive/9ebc6ad944c9e53f58536ef50c64b6f057e5fa4c.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "1hv53kw8nwg9k3kim19ykbmn3yksgmlw1gjbd6d5midhmjjc6mhv";
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
      pkgs.less
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.openjdk
      pkgs.pinentry
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
