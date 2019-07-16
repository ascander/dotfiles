# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  pkgs = pkgs-unstable;

  pkgs-unstable = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-master-2019-07-15";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-unstable`
    url = "https://github.com/nixos/nixpkgs/archive/31c38894c90429c9554eab1b416e59e3b6e054df.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "1fv14rj5zslzm14ak4lvwqix94gm18h28376h4hsmrqqpnfqwsdw";
  }) {};

  hub = pkgs.gitAndTools.hub;

  lab = pkgs-unstable.gitAndTools.lab;

  custom = rec {
    inherit (pkgs) callPackage;

    ddgr = pkgs.ddgr;

    # Git with config baked in
    git = callPackage ./git {};

    pure-prompt = callPackage ./zsh/pure-prompt.nix {};

    # silver-searcher with environment setup
    silver-searcher = callPackage ./silver-searcher {};

    # Zsh with config baked in
    zsh = callPackage ./zsh {
      site-functions = builtins.map
        (p: "${p}/share/zsh/site-functions")
        [ ddgr pure-prompt hub lab pkgs.nix-zsh-completions ];
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

    vim = pkgs-unstable.callPackage ./vim {
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
