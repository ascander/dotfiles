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

  custom = rec {
    inherit (pkgs) callPackage;

    git = callPackage ./git {};
    zshrc = callPackage ./zshrc {};
    geometry-zsh = callPackage ./zshrc/geometry-zsh.nix {};
    dircolors-solarized = callPackage ./zshrc/dircolors-solarized.nix {};
    metals = pkgs.callPackage ./metals {};
    fzf = pkgs.callPackage ./fzf {};

    # Convert 'yarn.lock' files into Nix expressions
    yarn2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "moretea";
      repo = "yarn2nix";
      rev = "3cc020e384ce2a439813adb7a0cc772a034d90bb";
      sha256 = "0h2kzdfiw43rbiiffpqq9lkhvdv8mgzz2w29pzrxgv8d39x67vr9";
    }) {};

    # The *other* editor
    vim = pkgs-darwin.callPackage ./vim {
      inherit metals yarn2nix;
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    };
  };

  allPlatforms = with custom;
    [
      # Customized packages
      fzf
      git
      hub
      metals
      vim
      zshrc
      geometry-zsh
      dircolors-solarized

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.emacs
      pkgs.fasd
      pkgs.gawk
      pkgs.less
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.nodejs               # TODO migrate globally installed node packages to Nix
      pkgs.openjdk
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
