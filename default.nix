# Main nix environment setup script.
#
# Based on https://github.com/nmattia/homies/blob/master/default.nix
let

  pkgs-darwin = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixpkgs-19.09-darwin";
    # rev obtained with `git ls-remote https://github.com/nixos/nixpkgs-channels nixpkgs-darwin`
    url = "https://github.com/nixos/nixpkgs/archive/bb7c495f2e74bf49c32b14051c74b3847e1e2be0.tar.gz";
    # hash obtained with `nix-prefetch-url --unpack <url from above>`
    sha256 = "0dm57i9cpyi55h519vc6bc9dlcmxr3aa4pf9pkff6lnkrywi30nm";
  }) { overlays = [emacs-overlay]; };

  # Use the "official" emacs overlay to get current builds
  emacs-overlay = import (builtins.fetchGit {
    url = "git@github.com:nix-community/emacs-overlay.git";
    ref = "master";
    rev = "020d3009feffb10bb3d43d3b69882ee7fc9a2b50"; # pinned to 02/27/2020
  });

  pkgs = pkgs-darwin;
  hub = pkgs.gitAndTools.hub;
  pinentry = if (pkgs.stdenv.isDarwin) then pkgs.pinentry_mac else pkgs.pinentry;

  # Bleeding edge Emacs slows way down in fullscreen on MacOS; running the
  # latest Emacs 27 seems to work okay.
  emacs27 = pkgs.emacsGit.overrideAttrs(old: {
    src = pkgs.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "f9e53947c71ddf7f8d176a23c0a585fafa13b952"; # emacs-27 branch
      sha256 = "1hjnvbpa7iirh2hgqw707az13788hjffkg29r74hk9pikmyq0dxz";
    };
  });

  # See: https://nixos.org/nixos/manual/index.html#module-services-emacs-adding-packages
  myEmacsWithPackages = (pkgs.emacsPackagesGen emacs27).emacsWithPackages;

  # Currently vterm support requires building with the 'libvterm' library and
  # the 'emacs-libvterm' package. Longer term, all packages should be moved here
  # and pinned to the appropriate version of 'emacs-overlay'
  emacs = myEmacsWithPackages (epkgs: (with epkgs.melpaPackages; [
    vterm
  ]));

  custom = rec {
    inherit (pkgs) callPackage;

    git = callPackage ./git {};
    zshrc = callPackage ./zshrc {};
    geometry-zsh = callPackage ./zshrc/geometry-zsh.nix {};
    dircolors-solarized = callPackage ./zshrc/dircolors-solarized.nix {};
    metals = callPackage ./metals {};
    fzf = callPackage ./fzf {};

    # Convert 'yarn.lock' files into Nix expressions
    yarn2nix = callPackage (pkgs.fetchFromGitHub {
      owner = "moretea";
      repo = "yarn2nix";
      rev = "3cc020e384ce2a439813adb7a0cc772a034d90bb";
      sha256 = "0h2kzdfiw43rbiiffpqq9lkhvdv8mgzz2w29pzrxgv8d39x67vr9";
    }) {};

    # The *other* editor
    vim = callPackage ./vim {
      inherit metals yarn2nix;
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    };
  };

  allPlatforms = with custom;
    [
      # Customized packages
      emacs
      fzf
      git
      hub
      metals
      vim
      zshrc
      geometry-zsh
      dircolors-solarized
      pinentry

      # Vernilla packages
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.fasd
      pkgs.gawk
      pkgs.gnupg
      pkgs.jq
      pkgs.less
      pkgs.libvterm-neovim
      pkgs.nix
      pkgs.nix-zsh-completions
      pkgs.nodejs               # TODO migrate globally installed node packages to Nix
      pkgs.openjdk
      pkgs.ripgrep
      pkgs.tree
      pkgs.zsh-completions
      pkgs.zsh-syntax-highlighting
    ];

  # The list of packages to be installed
  tools = allPlatforms;
in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = tools; }
  else tools
