# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  pkgs = pkgs-darwin;

  pkgs-darwin = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-19.09-darwin";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-darwin`
    url = "https://github.com/nixos/nixpkgs/archive/bb7c495f2e74bf49c32b14051c74b3847e1e2be0.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "0dm57i9cpyi55h519vc6bc9dlcmxr3aa4pf9pkff6lnkrywi30nm";
  }) {};

  hub = pkgs.gitAndTools.hub;

  lab = pkgs-darwin.gitAndTools.lab;

  custom = rec {
    inherit (pkgs) callPackage;

    ddgr = pkgs.ddgr;

    # Git with config baked in
    git = callPackage ./git {};

    pure-prompt = callPackage ./zsh/pure-prompt.nix {};

    # Zsh with config baked in
    zsh = callPackage ./zsh {
      site-functions = builtins.map
        (p: "${p}/share/zsh/site-functions")
        [ ddgr pure-prompt hub pkgs.nix-zsh-completions ];
    };

    # Tmux with a custom tmux.conf baked in
    tmux = callPackage ./tmux {
      reattach-to-user-namespace = if (pkgs.stdenv.isDarwin) then pkgs.reattach-to-user-namespace else null;
    };

    metals = pkgs.callPackage ./metals {};

    fzf = pkgs.callPackage ./fzf {};

    yarn2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "moretea";
      repo = "yarn2nix";
      rev = "3cc020e384ce2a439813adb7a0cc772a034d90bb";
      sha256 = "0h2kzdfiw43rbiiffpqq9lkhvdv8mgzz2w29pzrxgv8d39x67vr9";
    }) {};

    emacsHead = pkgs.emacs.overrideAttrs (oldAttrs: rec {
      name = "emacs-${version}";
      version = "27.0";
      srcRepo = true;
      src = pkgs.fetchFromGitHub {
        owner = "emacs-mirror";
        repo = "emacs";
        rev = "a76a1d0c0b5c63bbed4eeeb7aa87269621956559";
        sha256 = "0cx7ahk18amqlivmpxvq9d3a9axbj5ag6disssxkbn8y7bib0s0i";
      };
      patches = [];
    });

    vim = pkgs-darwin.callPackage ./vim {
      inherit metals yarn2nix;
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    };
  };

  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  allPlatforms = with custom;
    [
      # Customized packages
      ddgr
      fzf
      git
      metals
      tmux
      vim
      zsh

      pkgs.bash
      pkgs.cacert
      pkgs.coreutils-prefixed
      pkgs.emacs
      pkgs.fasd
      pkgs.gawk
      pkgs.gnupg
      hub
      lab
      pkgs.less
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.openjdk
      pkgs.pinentry
      pkgs.ripgrep
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
